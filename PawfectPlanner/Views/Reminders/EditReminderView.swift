//
//  EditReminderView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 10/03/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct EditReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var fontSettings: FontSettings
    @State var reminder: Reminder // Editable reminder
    @State private var showPetSelection = false
    @State private var showEventSelection = false

    let onSave: (Reminder) -> Void // Callback to save changes
    
    @State private var showWeekdayPicker = false
    @State private var showDatePicker = false
    @State private var selectedWeekday: String = "Sunday" // Default weekday for weekly
    let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let frequencyOptions = ["Once", "Daily", "Weekly", "Monthly", "Yearly"]
    
    private func updateReminderInFirestore(_ reminder: Reminder) {
        let db = Firestore.firestore()
        
        guard !reminder.id.isEmpty else {
            print("❌ Reminder ID is missing!")
            return
        }

        let reminderRef = db.collection("reminders").document(reminder.id)

        let updatedData: [String: Any] = [
            "title": reminder.title,
            "pet": reminder.pet,
            "event": reminder.event,
            "isRepeat": reminder.isRepeat,
            "frequency": reminder.frequency,
            "time": Timestamp(date: reminder.time), // Convert Date to Firestore Timestamp
            "isCompleted": reminder.isCompleted
        ]

        reminderRef.updateData(updatedData) { error in
            if let error = error {
                print("Firestore Update Error: \(error.localizedDescription)")
            } else {
                print("Reminder successfully updated in Firestore!")
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss() // Close view after saving
                }
            }
        }
    }



    var body: some View {
        VStack {
            editReminderHeader()
            editReminderSelectionFields()
            editReminderTitleField()
            editReminderFrequencyField()
//            editReminderDateAndTimeFields()
            editReminderSaveButton()
            Spacer()
        }
    }

    // Function for header
    private func editReminderHeader() -> some View {
        Text("EDIT REMINDER")
            .font(.system(size: 30))
            .fontWeight(.bold)
            .foregroundColor(.brown)
            .padding(.top, 20)
    }

    // Function for reminder title field
    private func editReminderTitleField() -> some View {
        TextField("Reminder Title", text: $reminder.title)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
            .padding(.horizontal)
            .font(.system(size: fontSettings.fontSize))

    }

    // Function for Pet & Event Selection
    private func editReminderSelectionFields() -> some View {
        HStack {
            Button(action: { showPetSelection = true }) {
                VStack {
                    Circle()
                        .fill(reminder.pet.isEmpty ? Color.tailwindBrown1 : Color.brown)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Group {
                                if !reminder.pet.isEmpty {
                                    Text(String(reminder.pet.prefix(2)))
                                        .font(.system(size: fontSettings.fontSize))
                                } else {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.brown)                                .font(.system(size: fontSettings.fontSize))

                                }
                            }
                        )
                    Text(reminder.pet.isEmpty ? "Pet" : String(reminder.pet.dropFirst(2)))
                        .font(.system(size: fontSettings.fontSize))
                        .foregroundColor(Color.brown)
                }
            }
            .sheet(isPresented: $showPetSelection) {
                SelectPetView(selectedPet: Binding(
                    get: { reminder.pet },
                    set: { newValue in reminder.pet = newValue ?? "" }
                ))
            }

            Button(action: { showEventSelection = true }) {
                VStack {
                    Circle()
                        .fill(reminder.event.isEmpty ? Color.tailwindBrown1 : Color.brown)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Group {
                                if !reminder.event.isEmpty {
                                    Text(String(reminder.event.prefix(2)))
                                        .font(.system(size: fontSettings.fontSize))
                                } else {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.brown)                                .font(.system(size: fontSettings.fontSize))

                                }
                            }
                        )
                    Text(reminder.event.isEmpty ? "Event" : String(reminder.event.dropFirst(2)))
                        .font(.system(size: fontSettings.fontSize))
                        .foregroundColor(Color.brown)
                }
            }
            .sheet(isPresented: $showEventSelection) {
                SelectEventView(selectedEvent: Binding(
                    get: { reminder.event },
                    set: { newValue in reminder.event = newValue ?? "" }
                ))
            }
        }
    }
    
    private func editReminderFrequencyField() -> some View {
            VStack {
                HStack {
                    Text("Frequency")
                        .font(.system(size: fontSettings.fontSize))
//                        .foregroundColor(Color.brown)
                    Spacer()
                    Menu {
                        ForEach(["Once", "Daily", "Weekly", "Monthly", "Yearly"], id: \.self) { option in
                            Button(option) {
                                reminder.frequency = option
                            }
                        }
                    } label: {
                        Text(reminder.frequency)
                            .font(.system(size: fontSettings.fontSize))
                            .foregroundColor(.blue)
                            .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
                .padding(.horizontal)

                // One-time Reminders → Date & Time
                if reminder.frequency == "Once" {
                    DatePicker("Date", selection: $reminder.time, displayedComponents: .date)
//                        .labelsHidden()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
                        .padding(.horizontal)
                        .font(.system(size: fontSettings.fontSize))


                    DatePicker("Time", selection: $reminder.time, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
                        .padding(.horizontal)
                        .font(.system(size: fontSettings.fontSize))

                }

                // Daily Reminders → Time Only
                if reminder.frequency == "Daily" {
                    DatePicker("Time", selection: $reminder.time, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
                        .padding(.horizontal)
                        .font(.system(size: fontSettings.fontSize))

                }

                // Weekly Reminders → Select Weekday & Time
                if reminder.frequency == "Weekly" {
                    HStack {
                        Text("Weekday")
                            .font(.system(size: fontSettings.fontSize))
                        Spacer()
                        Menu {
                            ForEach(weekdays, id: \.self) { day in
                                Button(day) {
                                    selectedWeekday = day
                                    reminder.frequency = "Weekly (\(day))"
                                }
                            }
                        } label: {
                            Text(selectedWeekday)
                                .font(.system(size: fontSettings.fontSize))
                                .foregroundColor(.blue)
                                .padding(.horizontal)
                            
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
                    .padding(.horizontal)

                    DatePicker("Time", selection: $reminder.time, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
                        .padding(.horizontal)
                }

                // Monthly/Yearly Reminders → Select Date & Time
                if reminder.frequency == "Monthly" || reminder.frequency == "Yearly" {
                    DatePicker("Date", selection: $reminder.time, displayedComponents: .date)
//                        .labelsHidden()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
                        .padding(.horizontal)
                        .font(.system(size: fontSettings.fontSize))


                    DatePicker("Time", selection: $reminder.time, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
                        .padding(.horizontal)
                        .font(.system(size: fontSettings.fontSize))

                }
            }
        }


    // Function for Date & Time Fields
    private func editReminderDateAndTimeFields() -> some View {
        VStack {
            DatePicker("Date", selection: $reminder.time, displayedComponents: .date)
//                .labelsHidden()
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
                .padding(.horizontal)
                .font(.system(size: fontSettings.fontSize))


            DatePicker("Time", selection: $reminder.time, displayedComponents: .hourAndMinute)
//                .labelsHidden()
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
                .padding(.horizontal)
                .font(.system(size: fontSettings.fontSize))

        }
    }

    // Function for Save Button
    private func editReminderSaveButton() -> some View {
        Button(action: {
            onSave(reminder)
            updateReminderInFirestore(reminder)
        }) {
            Text("SAVE")
                .font(.system(size: fontSettings.fontSize))
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: 100)
                .background(Color.tailwindPink2)
                .foregroundColor(.white)
                .cornerRadius(20)
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }

}

// Preview for UI testing
struct EditReminderView_Previews: PreviewProvider {
    static var previews: some View {
        EditReminderView(
            reminder: Reminder(
                id: UUID().uuidString,
                title: "Bath time",
                pet: "🐶 Buddy",
                event: "🛁 Bath",
                isRepeat: true,
                frequency: "Weekly",
                time: Date(),
                isCompleted: false
            ),
            onSave: { _ in }
        ).environmentObject(FontSettings())
    }
}

