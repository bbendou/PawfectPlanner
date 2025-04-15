import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @Binding var selectedTab: String
    @EnvironmentObject var fontSettings: FontSettings

    @State private var petName: String?
    @State private var petBreed: String?
    @State private var petBirthDate: Date?
    @State private var petImage: UIImage?
    @State private var showEditPetView = false

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

                        if let name = petName, let breed = petBreed, let birthDate = petBirthDate {
                            VStack(spacing: 16) {
                                if let image = petImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200, height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                }

                                Text(name)
                                    .font(.system(size: fontSettings.fontSize + 3))

                                Text("Breed: \(breed)")
                                    .font(.system(size: fontSettings.fontSize))

                                Text("Age: \(calculateAge(from: birthDate))")
                                    .font(.system(size: fontSettings.fontSize))

                                NavigationLink(
                                    destination: AddPetView(
                                        selectedTab: $selectedTab,
                                        isEditMode: true,
                                        initialName: name,
                                        initialBreed: breed,
                                        initialBirthDate: birthDate,
                                        initialImage: petImage
                                    ),
                                    isActive: $showEditPetView
                                ) {
                                    Button(action: {
                                        showEditPetView = true
                                    }) {
                                        Label("Edit Pet", systemImage: "pencil")
                                            .padding()
                                            .frame(width: 260)
                                            .font(.system(size: fontSettings.fontSize))

                                    }
                                    .buttonStyle(PetRoundedButtonStyle())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        } else {
                            Button(action: {
                                selectedTab = "AddPet"
                            }) {
                                Label("Add Pet", systemImage: "plus.circle")
                                    .padding()
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
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PetDataUpdated")), perform: { _ in
                loadPetData()
            })
            .edgesIgnoringSafeArea(.bottom)
        }
    }

    private func loadPetData() {
        guard let user = Auth.auth().currentUser else {
            print("❌ No logged-in user found")
            return
        }

        let userID = user.uid
        let petKey = "petDetails_\(userID)"
        let imageKey = "petImage_\(userID)"

        if let savedData = UserDefaults.standard.dictionary(forKey: petKey) {
            petName = savedData["name"] as? String
            petBreed = savedData["breed"] as? String

            if let birthDateString = savedData["birthDate"] as? String {
                let formatter = ISO8601DateFormatter()
                if let birthDate = formatter.date(from: birthDateString) {
                    petBirthDate = birthDate
                }
            }
        }

        if let imageData = UserDefaults.standard.data(forKey: imageKey),
           let image = UIImage(data: imageData) {
            petImage = image
        }

        print("✅ Loaded Pet Data for user \(userID)")
    }

    private func calculateAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year ?? 0
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
    }
}
