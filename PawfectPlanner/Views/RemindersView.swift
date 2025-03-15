//
//  RemindersView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 09/03/2025.
//
import SwiftUI

struct RemindersView: View {
    @State private var showAddReminderForm = false
    @State private var reminders: [Reminder] = [] // Stores added reminders
    @State private var showEditReminderForm = false
    @State private var editingReminder: Reminder? // Tracks which reminder is being edited

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
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    Image(systemName: "arrow.down")
                        .foregroundColor(.brown)
                }
                .padding(.bottom, 20) // Moves it closer to the + button
            } else {
                // Display List of Reminders
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(reminders) { reminder in
                            ReminderCard(
                                reminder: reminder,
                                onDelete: { deleteReminder(reminder) },
                                onEdit: {
                                    DispatchQueue.main.async {
                                        editingReminder = reminder // Assign the reminder to be edited
                                    }
                                    showEditReminderForm = true
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
            .sheet(isPresented: $showAddReminderForm) {
                AddReminderView { newReminder in
                    reminders.append(newReminder) // Store the new reminder
                }
            }
            .sheet(item: $editingReminder) { reminder in
                EditReminderView(
                    reminder: reminder,
                    onSave: { updatedReminder in
                        updateReminder(updatedReminder) // Save changes
                    }
                )
            }



        }
        .edgesIgnoringSafeArea(.bottom)
    }

    private func deleteReminder(_ reminder: Reminder) {
        NotificationManager.shared.removeNotification(reminder: reminder) // Remove notification
        reminders.removeAll { $0.id == reminder.id }
    }

    
    private func editReminder(_ reminder: Reminder) {
        editingReminder = reminder
        showEditReminderForm = true
    }

    
    private func updateReminder(_ updatedReminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == updatedReminder.id }) {
            reminders[index] = updatedReminder
        }
    }


}


struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
    }
}
