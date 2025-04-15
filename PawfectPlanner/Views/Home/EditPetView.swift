//
//  EditPetView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 15/04/2025.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct EditPetView: View {
    let petID: String
    let initialName: String
    let initialBreed: String
    let initialBirthDate: Date
    let initialImage: UIImage?
    let initialType: String

    @Environment(\.presentationMode) var presentationMode
    @State private var name: String
    @State private var breed: String
    @State private var birthDate: Date
    @State private var petType: String
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    init(petID: String, initialName: String, initialBreed: String, initialBirthDate: Date, initialImage: UIImage?, initialType: String) {
        self.petID = petID
        self.initialName = initialName
        self.initialBreed = initialBreed
        self.initialBirthDate = initialBirthDate
        self.initialImage = initialImage
        self.initialType = initialType

        _name = State(initialValue: initialName)
        _breed = State(initialValue: initialBreed)
        _birthDate = State(initialValue: initialBirthDate)
        _petType = State(initialValue: initialType)
        _selectedImage = State(initialValue: initialImage)
    }

    var body: some View {
        Form {
            Section(header: Text("Pet Info")) {
                TextField("Name", text: $name)
                TextField("Breed", text: $breed)
                DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
                Picker("Type", selection: $petType) {
                    Text("Dog").tag("Dog")
                    Text("Cat").tag("Cat")
                    Text("Other").tag("Other")
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Picture")) {
                VStack(alignment: .center) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.bottom, 8)
                    } else {
                        Text("No image selected")
                            .foregroundColor(.gray)
                    }

                    Button("Select New Image") {
                        isImagePickerPresented = true
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }

            Section {
                Button(action: updatePet) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.tailwindPink2)
                .cornerRadius(10)
            }
        }
        .navigationTitle("Edit Pet")
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                if alertMessage.contains("success") {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }

    private func updatePet() {
        guard let userID = Auth.auth().currentUser?.uid else {
            alertMessage = "No logged-in user."
            showAlert = true
            return
        }

        let db = Firestore.firestore()
        let formatter = ISO8601DateFormatter()
        let birthDateStr = formatter.string(from: birthDate)

        let updatedData: [String: Any] = [
            "name": name,
            "breed": breed,
            "birthDate": birthDateStr,
            "type": petType,
            "userID": userID
        ]

        db.collection("pets").document(petID).updateData(updatedData) { error in
            if let error = error {
                alertMessage = "Failed to update pet: \(error.localizedDescription)"
            } else {
                if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
                    let imageKey = "petImage_\(petID)"
                    UserDefaults.standard.set(imageData, forKey: imageKey)
                    UserDefaults.standard.synchronize()
                }
                NotificationCenter.default.post(name: NSNotification.Name("PetDataUpdated"), object: nil)
                alertMessage = "Pet updated successfully!"
            }
            showAlert = true
        }
    }
}

struct EditPetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditPetView(
                petID: "sampleID",
                initialName: "Zeke",
                initialBreed: "Golden Retriever",
                initialBirthDate: Date(),
                initialImage: nil,
                initialType: "Dog"
            )
        }
    }
}
