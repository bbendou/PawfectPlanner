import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View {
    @Binding var selectedTab: String
    @EnvironmentObject var fontSettings: FontSettings

    @State private var pets: [PetDisplay] = []
    @State private var showSuccessAlert = false
    @State private var successMessage = ""
    @State private var selectedPetToEdit: PetDisplay? = nil
    @State private var showDeleteConfirmation = false
    @State private var petToDelete: PetDisplay? = nil
    
    @State private var safariURL: URL? = nil
    @State private var showSafari = false


    struct PetDisplay: Identifiable {
        let id: String
        let name: String
        let breed: String
        let birthDate: Date
        let image: UIImage?
        let type: String
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Text("Home")
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.tailwindBlue900)
                    .foregroundColor(.white)

                ScrollView {
                    VStack(spacing: 32) {
                        Spacer().frame(height: 40)

                        if !pets.isEmpty {
                            HStack {
                                Spacer()
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(pets) { pet in

                                            VStack(spacing: 10) {
                                                if let image = pet.image {
                                                    Image(uiImage: image)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 200, height: 200)
                                                        .clipped()
                                                        .cornerRadius(16)
                                                }

                                                Text("\(pet.name)")
                                                    .font(.system(size: fontSettings.fontSize + 5))

                                                Text("Breed: \(pet.breed)")
                                                    .font(.system(size: fontSettings.fontSize))

                                                Text("Age: \(calculateAge(from: pet.birthDate))")
                                                    .font(.system(size: fontSettings.fontSize))
                                                
                                                let isValid = isValidBreed(pet.breed) && (pet.type.lowercased() == "dog" || pet.type.lowercased() == "cat")

                                                Button("Learn More") {
                                                    let formattedBreed = pet.breed.lowercased().replacingOccurrences(of: " ", with: "-")
                                                    let base = pet.type.lowercased() == "dog" ? "dog" : "cat"
                                                    let urlString = "https://www.petguide.com/breeds/\(base)/\(formattedBreed)"
                                                    if let url = URL(string: urlString) {
                                                        UIApplication.shared.open(url)
                                                    }
                                                }
                                                .font(.system(size: 14))
                                                .foregroundColor(.blue)
                                                .opacity(isValid ? 1.0 : 0.4)
                                                .disabled(!isValid)


                                                HStack(spacing: 10) {
                                                    NavigationLink(destination: EditPetView(
                                                        petID: pet.id,
                                                        initialName: pet.name,
                                                        initialBreed: pet.breed,
                                                        initialBirthDate: pet.birthDate,
                                                        initialImage: pet.image,
                                                        initialType: pet.type
                                                    )) {
                                                        Label("Edit", systemImage: "pencil")
                                                            .frame(minWidth: 80)
                                                            .padding(10)
                                                    }
                                                    .buttonStyle(PetRoundedButtonStyle())

                                                    Button(action: {
                                                        petToDelete = pet
                                                        showDeleteConfirmation = true
                                                    }) {
                                                        Label("Delete", systemImage: "trash")
                                                            .frame(minWidth: 80)
                                                            .padding(10)
                                                    }
                                                    .buttonStyle(PetRoundedButtonStyle())
                                                }
                                                .padding(.top, 10)
                                            }
                                            .padding()
                                            .frame(width: 300, height: 500)
                                            .background(Color.white)
                                            .cornerRadius(20)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                            )
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                Spacer()
                            }
                        } else {
                            Text("No pets found. Please add a pet.")
                                .foregroundColor(.gray)
                                .padding()
                            
                            Button(action: {
                                selectedTab = "AddPet"
                            }) {
                                Label("Add Pet", systemImage: "plus.circle")
                                    .padding()
                                    .font(.system(size: fontSettings.fontSize))
                                    .frame(width: 260)
                            }
                            .buttonStyle(PetRoundedButtonStyle())
                        }

                        Button(action: {
                            selectedTab = "Journal"
                        }) {
                            Label("Journal", systemImage: "book")
                                .padding()
                                .frame(width: 260)
                                .font(.system(size: fontSettings.fontSize))
                        }
                        .buttonStyle(PetRoundedButtonStyle())

                        Spacer(minLength: 100)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }
                .background(Color.white)
            }
            .onAppear(perform: loadPetData)
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PetDataUpdated"))) { _ in
                loadPetData()
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(title: Text("Success"), message: Text(successMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Pet"),
                    message: Text("Are you sure you want to delete this pet? This will delete all data of your pet."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let pet = petToDelete {
                            deletePet(pet)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .sheet(isPresented: $showSafari) {
            if let url = safariURL {
                SafariView(url: url)
            }
        }

    }
    
    func isValidBreed(_ breed: String) -> Bool {
        let trimmed = breed.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.range(of: #"[^a-zA-Z\s\-]"#, options: .regularExpression) == nil
    }


    private func loadPetData() {
        guard let user = Auth.auth().currentUser else {
            print("❌ No logged-in user found")
            return
        }

        let db = FirebaseFirestore.Firestore.firestore()
        db.collection("pets")
            .whereField("userID", isEqualTo: user.uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Firestore error: \(error.localizedDescription)")
                    return
                }

                var loadedPets: [PetDisplay] = []
                let formatter = ISO8601DateFormatter()

                snapshot?.documents.forEach { doc in
                    let data = doc.data()
                    let name = data["name"] as? String ?? "Unnamed"
                    let breed = data["breed"] as? String ?? "Unknown"
                    let type = data["type"] as? String ?? "Other"
                    let birthDateString = data["birthDate"] as? String ?? ""
                    let birthDate = formatter.date(from: birthDateString) ?? Date()

                    let imageKey = "petImage_\(doc.documentID)"
                    var petImage: UIImage? = nil
                    if let imageData = UserDefaults.standard.data(forKey: imageKey) {
                        petImage = UIImage(data: imageData)
                    } else {
                        print("⚠️ No image found for key: \(imageKey)")
                    }

                    let pet = PetDisplay(id: doc.documentID, name: name, breed: breed, birthDate: birthDate, image: petImage, type: type)
                    loadedPets.append(pet)
                }

                DispatchQueue.main.async {
                    self.pets = loadedPets
                }
            }
    }

    private func deletePet(_ pet: PetDisplay) {
        let db = FirebaseFirestore.Firestore.firestore()
        db.collection("pets").document(pet.id).delete { error in
            if let error = error {
                print("❌ Failed to delete pet: \(error.localizedDescription)")
            } else {
                print("✅ Pet deleted: \(pet.name)")
                successMessage = "\(pet.name) has been deleted."
                showSuccessAlert = true
                loadPetData()
            }
        }
    }

    private func calculateAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year ?? 0
    }

    private func emoji(for type: String) -> String {
        switch type.lowercased() {
            case "dog": return "🐶"
            case "cat": return "🐱"
            default: return "🐾"
        }
    }
    
    private func breedURL(for type: String, breed: String) -> URL? {
        let formattedBreed = breed.lowercased().replacingOccurrences(of: " ", with: "-")
        let animalType = type.lowercased()

        guard animalType == "dog" || animalType == "cat" else { return nil }

        return URL(string: "https://www.petguide.com/breeds/\(animalType)/\(formattedBreed)/")
    }

    
    private func fallbackURL(for type: String) -> URL {
        return type.lowercased() == "dog"
            ? URL(string: "https://www.petguide.com/breeds/dog")!
            : URL(string: "https://www.petguide.com/breeds/cat")!
    }

    private func checkURLExists(primaryURL: URL, fallbackURL: URL) {
        var request = URLRequest(url: primaryURL)
        request.httpMethod = "HEAD"

        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                safariURL = primaryURL
            } else {
                safariURL = fallbackURL
            }

            DispatchQueue.main.async {
                showSafari = true
            }
        }.resume()
    }

}

// MARK: - Rounded Reusable Button Style
struct PetRoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(Color.brown)
            .background(Color.tailwindPink1)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant("Home"))
            .environmentObject(FontSettings())
    }
}
