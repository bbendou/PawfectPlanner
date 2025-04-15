//
//  AddPetView.swift
//  PawfectPlanner
//
//  Created by Sarim Faraz on 15/03/2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AddPetView: View {
    @Binding var selectedTab: String

    var isEditMode: Bool = false
    var initialName: String? = nil
    var initialBreed: String? = nil
    var initialBirthDate: Date? = nil
    var initialImage: UIImage? = nil

    @State private var petName: String = ""
    @State private var birthDate: Date = Date()
    @State private var breed: String = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var petType: String = "Cat"
    @State private var showConfirmation = false


    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text(isEditMode ? "Edit Your Pet" : "Add Your Pet")
                .font(.system(size: 32))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .frame(height: 94)
                .background(Color.tailwindBlue900)
                .foregroundColor(.white)
                .padding(.bottom, 10)
        }
        ScrollView {
            VStack(spacing: 0) {

                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Pet Name").font(.custom("Jersey10", size: 28))
                    TextField("Enter pet name", text: $petName)
                        .textFieldStyle(PetTextFieldStyle())
                }.padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Birth Date").font(.custom("Jersey10", size: 28))
                    DatePicker("Select Birthdate", selection: $birthDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(.horizontal)
                }.padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Breed").font(.custom("Jersey10", size: 28))
                    TextField("Enter breed", text: $breed)
                        .textFieldStyle(PetTextFieldStyle())
                }.padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Pet Type").font(.custom("Jersey10", size: 28))
                    
                    Picker("Select Pet Type", selection: $petType) {
                        Text("Dog").tag("Dog")
                        Text("Cat").tag("Cat")
                        Text("Other").tag("Other")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }
                .padding()
                
                
                VStack(spacing: 10) {
                    HStack {
                        Text("Picture")
                            .font(.custom("Jersey10", size: 28))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                    }
                    
                    Button(action: { isImagePickerPresented = true }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.tailwindPink1)
                                .shadow(radius: 4)
                                .frame(width: 142, height: 137)
                            
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 118)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }}.padding()

            Button(action: savePetData) {
                Text(isEditMode ? "SAVE" : "CREATE")
                    .font(.custom("Jersey10", size: 36))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 60)
                    .background(Color.tailwindPink2)
                    .cornerRadius(30)
                    .shadow(radius: 4)
            }
            .padding(.top, 20)

            Spacer()
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .background(Color.white)
        .onAppear {
            if isEditMode {
                petName = initialName ?? ""
                breed = initialBreed ?? ""
                birthDate = initialBirthDate ?? Date()
                selectedImage = initialImage
            }
        }.alert(isPresented: $showConfirmation) {
            Alert(
                title: Text("Success"),
                message: Text(isEditMode ? "Pet updated!" : "New pet added!"),
                dismissButton: .default(Text("OK")) {
                    selectedTab = "Home"
                }
            )
        }
    }

    private func savePetData() {
        guard let user = Auth.auth().currentUser else {
            print("No logged-in user found")
            return
        }

        let userID = user.uid
        let petKey = "petDetails_\(userID)"
        let imageKey = "petImage_\(userID)"
        let formatter = ISO8601DateFormatter()
        let birthDateString = formatter.string(from: birthDate)

        let petData: [String: Any] = [
            "name": petName,
            "birthDate": birthDateString,
            "breed": breed,
            "userID": userID,
            "type": petType,
            "createdAt": Timestamp(date: Date())
        ]

        let db = FirebaseFirestore.Firestore.firestore()
        db.collection("pets").addDocument(data: petData) { error in
            if let error = error {
                print("Firestore error: \(error.localizedDescription)")
            } else {
                print("Pet saved to Firestore for user \(userID)")

                // Save locally
                let localPetData: [String: Any] = [
                    "name": petName,
                    "birthDate": birthDateString,
                    "breed": breed
                ]
                UserDefaults.standard.set(localPetData, forKey: petKey)

                if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
                    UserDefaults.standard.set(imageData, forKey: imageKey)
                }

                UserDefaults.standard.synchronize()

                NotificationCenter.default.post(name: NSNotification.Name("PetDataUpdated"), object: nil)

                showConfirmation = true
            }
        }
    }



    struct PetTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding(12)
                .background(Color.tailwindPink1)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
        }
    }

    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var selectedImage: UIImage?
        @Environment(\.presentationMode) var presentationMode

        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = .photoLibrary
            return picker
        }

        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            let parent: ImagePicker

            init(_ parent: ImagePicker) {
                self.parent = parent
            }

            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[.originalImage] as? UIImage {
                    parent.selectedImage = image
                }
                parent.presentationMode.wrappedValue.dismiss()
            }

            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    struct AddPetView_Previews: PreviewProvider {
        static var previews: some View {
            AddPetView(selectedTab: .constant("Home"))
        }
    }
}
