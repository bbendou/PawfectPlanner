//
//  AddPetView.swift
//  PawfectPlanner
//
//  Created by Sarim Faraz on 15/03/2025.
//

import SwiftUI
import FirebaseAuth

struct AddPetView: View {
    @State private var petName: String = ""
    @State private var birthDate: Date = Date()
    @State private var breed: String = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @Binding var selectedTab: String // ✅ Binding to switch back to HomeView
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Add Your Pet")
                .font(.custom("Jersey10", size: 40))
                .frame(maxWidth: .infinity, minHeight: 94)
                .background(Color.tailwindBlue500)
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Pet Name").font(.custom("Jersey10", size: 28))
                TextField("Enter pet name", text: $petName).textFieldStyle(PetTextFieldStyle())
            }.padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Birth Date").font(.custom("Jersey10", size: 28))
                DatePicker("Select Birthdate", selection: $birthDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
            }.padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Breed").font(.custom("Jersey10", size: 28))
                TextField("Enter breed", text: $breed).textFieldStyle(PetTextFieldStyle())
            }.padding()
            
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
            }.padding()
            
            Button(action: savePetData) {
                Text("CREATE")
                    .font(.custom("Jersey10", size: 36))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 60)
                    .background(Color.tailwindBlue500)
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
    }
    
    private func savePetData() {
        guard let user = Auth.auth().currentUser else {
            print("❌ No logged-in user found")
            return
        }

        let userID = user.uid  // Get Firebase User ID
        let petKey = "petDetails_\(userID)"  // Unique storage key for this user
        let imageKey = "petImage_\(userID)"  // Unique image key

        let formatter = ISO8601DateFormatter()
        let birthDateString = formatter.string(from: birthDate) // ✅ Convert date to string

        let petData: [String: Any] = [
            "name": petName,
            "birthDate": birthDateString, // ✅ Store date as String
            "breed": breed
        ]

        UserDefaults.standard.set(petData, forKey: petKey)

        // ✅ Save Image as Data
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: imageKey)
        }

        UserDefaults.standard.synchronize() // ✅ Ensure data is written immediately

        print("✅ Pet Data Saved for user \(userID): \(petData)")

        // ✅ Notify HomeView to Refresh (Forcing UI Update)
        NotificationCenter.default.post(name: NSNotification.Name("PetDataUpdated"), object: nil)

        selectedTab = "Home"  // ✅ Navigate back to HomeView
    }
    
    // Custom Input Style
    struct PetTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding(12)
                .background(Color.tailwindPink1)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
        }
    }
    
    // Image Picker
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
