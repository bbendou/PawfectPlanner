//
//  SelectPetView.swift
//
//  SelectPetView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 09/03/2025.
//


import SwiftUI

struct SelectPetView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var fontSettings: FontSettings
    @Binding var selectedPet: String?

    let pets = ["🐱 Zeke", "🐱 Simba"]

    var body: some View {
        NavigationView {
            VStack {
                // Information text
                Text("To add more pets, go to the Settings page.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 5)

                // Pet list
                List(pets, id: \.self) { pet in
                    HStack {
                        Text(pet)
                            .font(.headline)
                        Spacer()
                        if selectedPet == pet {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: fontSettings.fontSize))
                        }
                    }
                    .contentShape(Rectangle()) // Makes the whole row tappable
                    .onTapGesture {
                        selectedPet = pet // Update selected pet
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            presentationMode.wrappedValue.dismiss() // Close the selection view
                        }
                    }
                }
            }
            .navigationTitle("Select a Pet")
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
}

struct SelectPetView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPetView(selectedPet: .constant("🐶 Buddy")).environmentObject(FontSettings())
    }
}
