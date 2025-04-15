//  SelectPetView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 09/03/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SelectPetView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var fontSettings: FontSettings
    @Binding var selectedPet: String?

    struct PetDisplay: Identifiable {
        let id: String
        let name: String
        let type: String
    }

    @State private var pets: [PetDisplay] = []


    var body: some View {
        NavigationView {
            VStack {
                // Information text
                Text("To add more pets, go to the Settings page.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 5)

                // Pet list
                List(pets) { pet in
                    HStack {
                        Text("\(emoji(for: pet.type)) \(pet.name)")
                            .font(.headline)
                        Spacer()
                        if selectedPet == "\(emoji(for: pet.type)) \(pet.name)" {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: fontSettings.fontSize))
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedPet = "\(emoji(for: pet.type)) \(pet.name)"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }

            }
            .navigationTitle("Select a Pet")
            .onAppear {
                fetchUserPets()
            }
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
    func fetchUserPets() {
        guard let user = Auth.auth().currentUser else {
            print("❌ No user logged in.")
            return
        }

        let db = Firestore.firestore()
        db.collection("pets")
            .whereField("userID", isEqualTo: user.uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching pets: \(error.localizedDescription)")
                    return
                }

                if let documents = snapshot?.documents {
                    let fetchedPets = documents.map { doc -> PetDisplay in
                        let name = doc["name"] as? String ?? "Unnamed Pet"
                        let type = doc["type"] as? String ?? "Unknown"
                        return PetDisplay(id: doc.documentID, name: name, type: type)
                    }

                    DispatchQueue.main.async {
                        self.pets = fetchedPets
                    }

                }
            }
    }
}

func emoji(for type: String) -> String {
    switch type.lowercased() {
        case "dog": return "🐶"
        case "cat": return "🐱"
        default: return "🐾"
    }
}


struct SelectPetView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPetView(selectedPet: .constant("🐶 Buddy")).environmentObject(FontSettings())
    }
}

