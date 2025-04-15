//
//  SelectEventView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 09/03/2025.
//

import SwiftUI

struct SelectEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var fontSettings: FontSettings
    @Binding var selectedEvent: String?

    let defaultEvents = [
        "🍽️ Food", "🧼 Bath", "✂️ Groom", "🚽 Potty", "💊 Medication", "🩺 Vet",
    ]

    let petActivityEmojis = ["🏥", "🎾", "🐾", "🛏️", "🦴", "🐶", "🎀", "🦷", "🏕️", "🎁"]

    @State private var customEvents: [String] = [] // Stores added custom events
    @State private var selectedEmoji: String = "🐾" // Default emoji selection
    @State private var customEventName: String = "" // Custom event name input
    @State private var showCustomEventField = false // Toggle for input field

    var body: some View {
        NavigationView {
            VStack {
                // Information text
                Text("To add more events, scroll down the page.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 5)

                List {
                    Section(header: Text("Default Events")) {
                        ForEach(defaultEvents, id: \.self) { event in
                            eventRow(event)
                        }
                    }

                    if !customEvents.isEmpty {
                        Section(header: Text("Custom Events")) {
                            ForEach(customEvents, id: \.self) { event in
                                eventRow(event)
                            }
                        }
                    }

                    // Button to add a new custom event
                    Button(action: {
                        showCustomEventField.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                            Text("Add Custom Event")
                                .foregroundColor(.blue)
                        }
                    }

                    // Custom Event Input Section
                    if showCustomEventField {
                        VStack {
                            // Emoji Picker
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(petActivityEmojis, id: \.self) { emoji in
                                        Text(emoji)
                                            .font(.system(size: fontSettings.fontSize))
                                            .padding(5)
                                            .background(selectedEmoji == emoji ? Color.blue.opacity(0.3) : Color.clear)
                                            .clipShape(Circle())
                                            .onTapGesture {
                                                selectedEmoji = emoji
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }

                            // Custom Event Name Input
                            HStack {
                                TextField("Enter event name", text: $customEventName)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))

                                Button("Save") {
                                    if isValidCustomEvent() {
                                        let newEvent = "\(selectedEmoji) \(customEventName)"
                                        customEvents.append(newEvent)
                                        customEventName = ""
                                        showCustomEventField = false
                                    }
                                }
                                .disabled(!isValidCustomEvent())
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select an Event")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left") // Back button
                            .foregroundColor(.blue)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    // Function to display each event row
    private func eventRow(_ event: String) -> some View {
        HStack {
            Text(event)
                .font(.headline)
            Spacer()
            if selectedEvent == event {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selectedEvent = event
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    // Function to check if the new event name is valid
    private func isValidCustomEvent() -> Bool {
        let trimmed = customEventName.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty
    }
}
