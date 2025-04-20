//
//  RemindersView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 09/03/2025.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct RemindersView: View {
    @EnvironmentObject var fontSettings: FontSettings
    
    @State private var selectedPriorityFilter: String = "All"
    let priorityOptions = ["All", "High", "Medium", "Low"]

    @State private var showAddReminderForm = false
 
    @State private var showEditReminderForm = false
    @State private var editingReminder: Reminder? // Tracks which reminder is being edited
    @State private var reminders: [Reminder] = []
    private let db = Firestore.firestore()

    
    private func fetchRemindersFromFirestore() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("❌ No authenticated user found.")
            return
        }

        db.collection("reminders")
            .whereField("userID", isEqualTo: userID) // Fetch only user's reminders
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Firestore Fetch Error: \(error.localizedDescription)")
                    return
                }

                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.reminders = snapshot.documents.compactMap { doc -> Reminder? in
                            let data = doc.data()
                            let priority = data["priority"] as? String ?? "Medium" // <-- fallback default
                            guard let title = data["title"] as? String,
                                  let pet = data["pet"] as? String,
                                  let event = data["event"] as? String,
                                  let isRepeat = data["isRepeat"] as? Bool,
                                  let frequency = data["frequency"] as? String,
                                  let timestamp = data["time"] as? Timestamp,
                                  let isCompleted = data["isCompleted"] as? Bool
                            else {
                                return nil
                            }

                            return Reminder(
                                id: doc.documentID,
                                title: title,
                                pet: pet,
                                event: event,
                                isRepeat: isRepeat,
                                frequency: frequency,
                                time: timestamp.dateValue(),
                                isCompleted: isCompleted,
                                priority: priority
                            )
                        }
                    }
                }
            }
    }



    var body: some View {
        VStack {
            // Title Bar
            Text("Reminders")
                .font(.system(size: 35))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.tailwindBlue900)
                .foregroundColor(.white)
            
            Spacer()
            
            if reminders.isEmpty {
                // No Reminders View
                Image(systemName: "bell.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(Color.tailwindBrown2)
                
                Text("NO REMINDERS SET!")
                    .font(.system(size: 25))
                    .foregroundColor(Color.tailwindBrown3)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.tailwindBrown1)
                    .cornerRadius(10)
                    .padding(.top, 10)
                
                Spacer()
                
                // Move text closer to + button
                VStack(spacing: 5) {
                    Text("Click here to add your first reminder!")
                        .font(.system(size: fontSettings.fontSize))
                        .foregroundColor(.gray)
                    
                    Image(systemName: "arrow.down")
                        .foregroundColor(.brown)
                }
                .padding(.bottom, 20) // Moves it closer to the + button
            } else {
                Menu {
                    ForEach(priorityOptions, id: \.self) { option in
                        Button(action: {
                            withAnimation {
                                selectedPriorityFilter = option
                            }
                        }) {
                            Text(option)
                        }
                    }
                } label: {
                    Label("Priority: \(selectedPriorityFilter)", systemImage: "line.horizontal.3.decrease.circle")
                        .foregroundColor(.brown)
                        .padding(.horizontal)
                }
                // Display List of Reminders
                ScrollView {
                    VStack(spacing: 10) {
                        let filteredReminders = reminders.filter { reminder in
                            selectedPriorityFilter == "All" || reminder.priority.lowercased() == selectedPriorityFilter.lowercased()
                        }
                        

                        ForEach(filteredReminders) { reminder in
                            ReminderCard(
                                reminder: reminder,
                                onDelete: { deleteReminder(reminder) },
                                onEdit: {
                                    DispatchQueue.main.async {
                                        editingReminder = reminder // Assign the reminder to be edited
                                    }
                                }
                            )
                        }
                    }
                    
                }
            }
            
            // Add Button
            Button(action: {
                showAddReminderForm = true
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding()
                    .background(Color.tailwindPink2)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5) // Stronger shadow
            }
            .padding(.bottom, 30)
        }
        .onAppear { 
                fetchRemindersFromFirestore()
            
        }
        .sheet(isPresented: $showAddReminderForm) {
            AddReminderView { newReminder in
                reminders.append(newReminder)
            }
        }
        .sheet(item: $editingReminder, onDismiss: {
            editingReminder = nil
        }) { reminder in
            EditReminderView(
                reminder: reminder,
                onSave: { updatedReminder in
                    updateReminder(updatedReminder)

                    if let index = reminders.firstIndex(where: { $0.id == updatedReminder.id }) {
                        reminders[index] = updatedReminder
                    }
                }
            )
        }
        .edgesIgnoringSafeArea(.bottom)
    }


    private func deleteReminder(_ reminder: Reminder) {
        db.collection("reminders").document(reminder.id).delete { error in
            if let error = error {
                print("❌ Error deleting reminder: \(error.localizedDescription)")
            } else {
                print("✅ Reminder deleted successfully.")
            }
        }
    }
    
    private func editReminder(_ reminder: Reminder) {
        editingReminder = reminder
        showEditReminderForm = true
    }

    
    private func updateReminder(_ updatedReminder: Reminder) {
        let db = Firestore.firestore()
        
        db.collection("reminders").document(updatedReminder.id).updateData([
            "title": updatedReminder.title,
            "pet": updatedReminder.pet,
            "event": updatedReminder.event,
            "isRepeat": updatedReminder.isRepeat,
            "frequency": updatedReminder.frequency,
            "time": Timestamp(date: updatedReminder.time),
            "isCompleted": updatedReminder.isCompleted
        ]) { error in
            if let error = error {
                print("❌ Firestore Update Error: \(error.localizedDescription)")
            } else {
                print("✅ Reminder successfully updated in Firestore!")
            }
        }
    }



}


struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
            .environmentObject(FontSettings())
    }
}
