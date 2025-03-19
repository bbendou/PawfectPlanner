//
//  AddReminderView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 09/03/2025.
//
import SwiftUI

struct AddReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var reminderTitle: String = ""
    @State private var selectedDate = Date()
    @State private var isNotificationOn = false
    @State private var isRepeat = false
    @State private var selectedFrequency: String = "Once" // Default to "Once"
    @State private var selectedWeekday: String = "Sunday" // Default weekday
    @State private var addToCalendar = false // Google Calendar toggle
    @State private var selectedPet: String? = nil
    @State private var selectedEvent: String? = nil
    @State private var showPetSelection = false
    @State private var showEventSelection = false
    @State private var showError = false // Controls error message visibility
    @State private var showWeekdayPicker = false // Controls weekday picker visibility
    @State private var showDatePicker = false // Controls date picker visibility

    let onSave: (Reminder) -> Void // Callback to pass data to home page
    
    let frequencyOptions = ["Daily", "Weekly", "Monthly", "Yearly"]
    let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        VStack {
//            // Title
//            Text("Reminders")
//                .font(.system(size: 35))
//                .fontWeight(.bold)
//                .frame(maxWidth: .infinity)
//                .frame(height: 60)
//                .background(Color.tailwindBlue900)
//                .foregroundColor(.white)
            
//            Spacer()
            
            // Form Container
            VStack(spacing: 15) {
                Text("ADD A NEW REMINDER")
                    .font(.system(size: 27))
                    .fontWeight(.bold)
                    .foregroundColor(Color.brown)
                    .padding(.top, 10)
                
                // Pet & Event Buttons
                HStack {
                    Button(action: { showPetSelection = true }) {
                        VStack {
                            Circle()
                                .fill(selectedPet == nil ? Color.tailwindBrown1 : Color.brown)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Group {
                                        if let pet = selectedPet {
                                            Text(String(pet.prefix(2))) // Extract emoji only
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
                            Text(selectedPet != nil ? String(selectedPet!.dropFirst(2)) : "Pet")
                                .font(.custom("PixelFont", size: 16))
                                .foregroundColor(Color.brown)
                        }
                    }
                    .sheet(isPresented: $showPetSelection) {
                        SelectPetView(selectedPet: $selectedPet)
                            .presentationDetents([.medium, .large])
                    }
                    
                    Button(action: { showEventSelection = true }) {
                        VStack {
                            Circle()
                                .fill(selectedEvent == nil ? Color.tailwindBrown1 : Color.brown)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Group {
                                        if let event = selectedEvent {
                                            Text(String(event.prefix(2))) // Extract emoji only
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
                            Text(selectedEvent != nil ? String(selectedEvent!.dropFirst(2)) : "Event")
                                .font(.custom("PixelFont", size: 16))
                                .foregroundColor(Color.brown)
                        }
                    }
                    .sheet(isPresented: $showEventSelection) {
                        SelectEventView(selectedEvent: $selectedEvent)
                            .presentationDetents([.medium, .large])
                    }
                }
                
                // Reminder Title Field
                TextField("Reminder Title", text: $reminderTitle)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 2))
                    .padding(.horizontal)
                
                // Once / Repeat Buttons
                HStack {
                    ToggleButton(title: "ONCE", isActive: !isRepeat) {
                        isRepeat = false
                    }
                    ToggleButton(title: "REPEAT", isActive: isRepeat) {
                        isRepeat = true
                    }
                }
                .padding(.horizontal)

                // Conditional View: Show Date Picker OR Repeat Fields
                if !isRepeat {
                    HStack {
                        Text("Date")
                            .font(.custom("PixelFont", size: 16))
                            .foregroundColor(Color.brown)
                        Spacer()
                        DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                            .labelsHidden()
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 2))
                    .padding(.horizontal)
                    
                    // Time Picker
                    HStack {
                        Text("Time")
                            .font(.custom("PixelFont", size: 16))
                            .foregroundColor(Color.brown)
                        Spacer()
                        DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 2))
                    .padding(.horizontal)
                    
                    // Notification Toggle
                    HStack {
                        Text("Notification")
                            .font(.custom("PixelFont", size: 16))
                            .foregroundColor(Color.brown)
                        Spacer()
                        Toggle("", isOn: $isNotificationOn)
                            .labelsHidden()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 2))
                    .padding(.horizontal)
                    
                    // Add to Google Calendar Toggle
                    HStack {
                        Text("Add to Apple Calendar")
                            .font(.custom("PixelFont", size: 16))
                            .foregroundColor(Color.brown)
                        Spacer()
                        Toggle("", isOn: $addToCalendar)
                            .labelsHidden()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 2))
                    .padding(.horizontal)
                }
                
                else {
                    VStack {
                        HStack {
                            Text("Frequency")
                                .font(.custom("PixelFont", size: 16))
                                .foregroundColor(Color.brown)
                            Spacer()
                            Menu {
                                ForEach(frequencyOptions, id: \.self) { option in
                                    Button(option) {
                                        selectedFrequency = option
                                        showWeekdayPicker = (option == "Weekly")
                                        showDatePicker = (option == "Monthly" || option == "Yearly")
                                    }
                                }
                            } label: {
                                Text(selectedFrequency)
                                    .font(.custom("PixelFont", size: 16))
//                                    .foregroundColor(.blue)
                                    .padding(.horizontal)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 2))
                        .padding(.horizontal)
                        
                        // Weekday Picker for Weekly Frequency
                        if showWeekdayPicker {
                            HStack {
                                Text("Select Day")
                                    .font(.custom("PixelFont", size: 16))
                                    .foregroundColor(Color.brown)
                                Spacer()
                                Menu {
                                    ForEach(weekdays, id: \.self) { day in
                                        Button(day) {
                                            selectedWeekday = day
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
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 2))
                            .padding(.horizontal)
                        }
                        
                        // Date Picker for Monthly & Yearly
                        if showDatePicker {
                            HStack {
                                Text("Select Date")
                                    .font(.custom("PixelFont", size: 16))
                                    .foregroundColor(Color.brown)
                                Spacer()
                                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                                    .labelsHidden()
                                    .background(Color.white)
                                    .cornerRadius(8)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 2))
                            .padding(.horizontal)
                        }
                    }
                        
                        // Time
                        HStack {
                            Text("Time")
                                .font(.custom("PixelFont", size: 16))
                                .foregroundColor(Color.brown)
                            Spacer()
                            DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 2))
                        .padding(.horizontal)
                        
                        
                        // Notification Toggle
                        HStack {
                            Text("Notification")
                                .font(.custom("PixelFont", size: 16))
                                .foregroundColor(Color.brown)
                            Spacer()
                            Toggle("", isOn: $isNotificationOn)
                                .labelsHidden()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 2))
                        .padding(.horizontal)
                        
                        // Add to Google Calendar Toggle
                        HStack {
                            Text("Add to Apple Calendar")
                                .font(.custom("PixelFont", size: 16))
                                .foregroundColor(Color.brown)
                            Spacer()
                            Toggle("", isOn: $addToCalendar)
                                .labelsHidden()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 2))
                        .padding(.horizontal)
                    }
                }

                // Show error message if fields are missing
                if showError {
                    Text("Please fill in all fields before adding a reminder!")
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .padding(.top, 5)
                }

                // ADD Button
                Button(action: {
                    if reminderTitle.isEmpty || selectedPet == nil || selectedEvent == nil {
                        showError = true // Show error message
                    } else {
                        let newReminder = Reminder(
                            title: reminderTitle,
                            pet: selectedPet ?? "Unknown Pet",
                            event: selectedEvent ?? "Unknown Event",
                            isRepeat: isRepeat,
                            frequency: selectedFrequency,
                            time: selectedDate,
                            isCompleted: false
                        )
                        onSave(newReminder) // Pass new reminder back to RemindersView
                        // ✅ Only schedule notification if toggle is ON
                        if isNotificationOn {
                            NotificationManager.shared.scheduleNotification(reminder: newReminder)
                        }
                        
                        // ✅ Add to Apple Calendar if the toggle is enabled
                        if addToCalendar {
                            CalendarManager.shared.addReminderToCalendar(title: reminderTitle, frequency: selectedFrequency, date: selectedDate) { success, error in
                                if success {
                                    print("✅ Successfully added to Apple Calendar")
                                } else {
                                    print("❌ Failed to add event: \(error?.localizedDescription ?? "Unknown error")")
                                }
                            }
                        }



                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("ADD")
                        .font(.custom("PixelFont", size: 18))
                        .padding()
                        .frame(maxWidth: 100)
                        .background(Color.tailwindPink2)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .padding(.horizontal)
                .padding(.vertical)

            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    

    
    struct ReminderTypeButton: View {
        let title: String
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack {
                    Circle()
                        .fill(isSelected ? Color.brown : Color.white)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(isSelected ? .white : .brown)
                        )
                    Text(title)
                        .font(.custom("PixelFont", size: 16))
                        .foregroundColor(Color.brown)
                }
            }
        }
    }
    
    struct ToggleButton: View {
        let title: String
        let isActive: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.custom("PixelFont", size: 16))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isActive ? Color.tailwindPink1 : Color.white)
                    .foregroundColor(.brown)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.brown, lineWidth: 2))
            }
        }
    }
    

//    struct AddReminderView_Previews: PreviewProvider {
//        static var previews: some View {
//            AddReminderView { _ in } // Dummy onSave function
//                .previewDevice("iPhone 15 Pro") // Specify a device
//                .previewLayout(.sizeThatFits)  // Ensure it fits
//        }
//    }
    
    struct AddReminderView_Previews: PreviewProvider {
        static var previews: some View {
            AddReminderView { _ in }
                .previewDevice("iPhone 15 Pro")
                .previewLayout(.sizeThatFits)
        }
        
        
    }
