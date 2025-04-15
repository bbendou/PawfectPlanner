//
//  RemindersCard.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 09/03/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ReminderCard: View {
    let reminder: Reminder
    let onDelete: () -> Void // Callback for deletion
    let onEdit: () -> Void // Callback for editing

    @State private var showDeleteConfirmation = false // Controls delete alert
    @State private var isChecked = false // Tracks checkbox state
    @EnvironmentObject var fontSettings: FontSettings
    
    private func deleteReminderFromFirestore(_ reminder: Reminder) {
        let db = Firestore.firestore()
        db.collection("reminders").document(reminder.id).delete { error in
            if let error = error {
                print("❌ Firestore Deletion Error: \(error.localizedDescription)")
            } else {
                print("✅ Reminder successfully deleted from Firestore!")
            }
        }
    }


    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // Reminder Title
                Text(reminder.title)
                    .font(.system(size: fontSettings.fontSize))
                    .bold()

                // Event & Pet
                Text("\(reminder.event) - \(reminder.pet)")
                    .font(.system(size: fontSettings.fontSize))
                    .foregroundColor(.gray)

                // Display frequency, weekday, or date
                if reminder.isRepeat {
                    if reminder.frequency.contains("Weekly") {
                        Text("\(reminder.frequency.replacingOccurrences(of: "Weekly (", with: "").replacingOccurrences(of: ")", with: ""))")
                            .font(.system(size: fontSettings.fontSize - 2))                            .foregroundColor(.tailwindBrown3)
                    } else if reminder.frequency.contains("Monthly") || reminder.frequency.contains("Yearly") {
                        Text("\(reminder.frequency.replacingOccurrences(of: "Monthly (", with: "").replacingOccurrences(of: "Yearly (", with: "").replacingOccurrences(of: ")", with: ""))")
                            .font(.system(size: fontSettings.fontSize - 2))
                            .foregroundColor(.tailwindBrown3)
                    } else {
                        Text(reminder.frequency)
                            .font(.system(size: fontSettings.fontSize - 2))
                            .foregroundColor(.tailwindBrown3)
                    }
                } else {
                    Text("\(formattedWeekdayAndDate(reminder.time))")
                        .font(.system(size: fontSettings.fontSize - 2))
                        .foregroundColor(.gray)
                }

                // Display Time
                Text(formattedTime(reminder.time))
                    .foregroundColor(.black)
                    .font(.system(size: fontSettings.fontSize - 3))
            }
            Spacer()

            // Edit Button (...)
            Menu {
                Button("Edit") {
                    DispatchQueue.main.async {
                        onEdit() // Ensures state update happens immediately
                    }
                }
                Button("Delete", role: .destructive) {
                    showDeleteConfirmation = true
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.gray)
            }


            // Checkbox Button
            Button(action: {
                isChecked.toggle()
                if reminder.isRepeat {
                    showDeleteConfirmation = true // Show warning alert for repeating reminders
                } else {
                    deleteReminderFromFirestore(reminder)
                }
            }) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(isChecked ? .green : .gray)
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Recurring Reminder?"),
                    message: Text("This reminder repeats. Are you sure you want to remove it from view?"),
                    primaryButton: .destructive(Text("Delete")) {
                        onDelete() // Call delete function
                    },
                    secondaryButton: .cancel {
                        isChecked = false // Reset checkbox if canceled
                    }
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(.horizontal)
        .padding(.top, 10) // Moves the card lower on the page
    }

    // Format time as "HH:MM AM/PM"
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }

    // Format weekday and date as "Monday, Mar 15"
    private func formattedWeekdayAndDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d" // "Monday, Mar 15"
        return formatter.string(from: date)
    }
}

