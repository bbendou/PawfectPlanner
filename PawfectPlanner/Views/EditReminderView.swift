//
//  EditReminderView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 10/03/2025.
//

import SwiftUI

struct EditReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var reminder: Reminder // Editable reminder
    @State private var showPetSelection = false
    @State private var showEventSelection = false

    let onSave: (Reminder) -> Void // Callback to save changes
    
    @State private var showWeekdayPicker = false
    @State private var showDatePicker = false
    @State private var selectedWeekday: String = "Sunday" // Default weekday for weekly
    let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let frequencyOptions = ["Once", "Daily", "Weekly", "Monthly", "Yearly"]

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
                                        .font(.system(size: 30))
                                } else {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.brown)
                                }
                            }
                        )
                    Text(reminder.pet.isEmpty ? "Pet" : String(reminder.pet.dropFirst(2)))
                        .font(.custom("PixelFont", size: 16))
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
                                        .font(.system(size: 30))
                                } else {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.brown)
                                }
                            }
                        )
                    Text(reminder.event.isEmpty ? "Event" : String(reminder.event.dropFirst(2)))
                        .font(.custom("PixelFont", size: 16))
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
                        .font(.custom("PixelFont", size: 16))
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
                            .font(.custom("PixelFont", size: 16))
                            .foregroundColor(.blue)
                            .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
                .padding(.horizontal)

                // **One-time Reminders → Date & Time**
                if reminder.frequency == "Once" {
                    DatePicker("Date", selection: $reminder.time, displayedComponents: .date)
//                        .labelsHidden()
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

                // **Daily Reminders → Time Only**
                if reminder.frequency == "Daily" {
                    DatePicker("Time", selection: $reminder.time, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
                        .padding(.horizontal)
                }

                // **Weekly Reminders → Select Weekday & Time**
                if reminder.frequency == "Weekly" {
                    HStack {
                        Text("Weekday")
                            .font(.custom("PixelFont", size: 16))
//                            .foregroundColor(Color.brown)
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
                                .font(.custom("PixelFont", size: 16))
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

                // **Monthly/Yearly Reminders → Select Date & Time**
                if reminder.frequency == "Monthly" || reminder.frequency == "Yearly" {
                    DatePicker("Date", selection: $reminder.time, displayedComponents: .date)
//                        .labelsHidden()
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

            DatePicker("Time", selection: $reminder.time, displayedComponents: .hourAndMinute)
//                .labelsHidden()
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 1))
                .padding(.horizontal)
        }
    }

    // Function for Save Button
    private func editReminderSaveButton() -> some View {
        Button(action: {
            onSave(reminder)
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("SAVE")
                .font(.custom("PixelFont", size: 18))
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
                title: "Bath time",
                pet: "🐶 Buddy",
                event: "🛁 Bath",
                isRepeat: true,
                frequency: "Weekly",
                time: Date(),
                isCompleted: false
            ),
            onSave: { _ in }
        )
    }
}
