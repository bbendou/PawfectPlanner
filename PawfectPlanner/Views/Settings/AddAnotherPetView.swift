//
//  AddAnotherPetView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 15/04/2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AddAnotherPetView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var petName: String = ""
    @State private var birthDate: Date = Date()
    @State private var breed: String = ""
    @State private var petType: String = "Cat"
    @State private var alertMessage = ""
    @State private var showAlert = false

    @State private var userPets: [PetDisplay] = []

    var body: some View {
        Form {
            Section(header: Text("Add New Pet")) {
                TextField("Name", text: $petName)
                TextField("Breed", text: $breed)

                Picker("Type", selection: $petType) {
                    Text("Dog").tag("Dog")
                    Text("Cat").tag("Cat")
                    Text("Other").tag("Other")
                }
                .pickerStyle(SegmentedPickerStyle())

                DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
            }

            Section {
                Button("Save Pet") {
                    savePetToFirestore()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.tailwindPink2)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Section(header: Text("Your Pets")) {
                if userPets.isEmpty {
                    Text("No pets added yet.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(userPets) { pet in
                        HStack {
                            Text("\(emoji(for: pet.type)) \(pet.name)")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(pet.breed)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle("Add Another Pet")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear {
            fetchUserPets()
        }
    }

    // MARK: - Pet Model
    struct PetDisplay: Identifiable {
        let id: String
        let name: String
        let breed: String
        let type: String
    }

    // MARK: - Save to Firestore
    func savePetToFirestore() {
        guard let user = Auth.auth().currentUser else {
            alertMessage = "No logged-in user found."
            showAlert = true
            return
        }

        let db = Firestore.firestore()
        let formatter = ISO8601DateFormatter()
        let petData: [String: Any] = [
            "name": petName,
            "breed": breed,
            "type": petType,
            "birthDate": formatter.string(from: birthDate),
            "userID": user.uid,
            "createdAt": Timestamp(date: Date())
        ]

        db.collection("pets").addDocument(data: petData) { error in
            if let error = error {
                alertMessage = "Failed to save pet: \(error.localizedDescription)"
            } else {
                alertMessage = "\(petName) added successfully!"
                fetchUserPets() // refresh pet list
                petName = ""
                breed = ""
                petType = "Cat"
                birthDate = Date()
            }
            showAlert = true
        }
    }

    // MARK: - Fetch User's Pets
    func fetchUserPets() {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user in fetchUserPets()")
            return
        }

        let db = Firestore.firestore()
        db.collection("pets")
            .whereField("userID", isEqualTo: user.uid)
            .order(by: "createdAt", descending: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Firestore error: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    return
                }

                print("Found \(documents.count) pets for user \(user.uid)")

                self.userPets = documents.map { doc in
                    PetDisplay(
                        id: doc.documentID,
                        name: doc["name"] as? String ?? "Unnamed",
                        breed: doc["breed"] as? String ?? "Unknown",
                        type: doc["type"] as? String ?? "Other"
                    )
                }
            }
    }


    // MARK: - Emoji Display
    func emoji(for type: String) -> String {
        switch type.lowercased() {
            case "dog": return "🐶"
            case "cat": return "🐱"
            default: return "🐾"
        }
    }
}

struct AddAnotherPetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddAnotherPetView()
        }
    }
}

