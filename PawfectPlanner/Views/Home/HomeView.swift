//
//  HomeView.swift
//  PawfectPlanner
//
//  Created by Sarim Faraz on 15/03/2025.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @Binding var selectedTab: String

    @State private var petName: String?
    @State private var petBreed: String?
    @State private var petBirthDate: Date?
    @State private var petImage: UIImage?
    @State private var showEditPetView = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Title Bar
                Text("Home")
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.tailwindBlue900)
                    .foregroundColor(.white)

                Spacer()

                VStack(spacing: 20) {
                    Spacer().frame(height: 120)

                    if let name = petName, let breed = petBreed, let birthDate = petBirthDate {
                        // ✅ Show Pet Details
                        VStack(spacing: 15) {
                            if let image = petImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            }

                            Text(name)
                                .font(.custom("Jersey10", size: 32))

                            Text("Breed: \(breed)")
                                .font(.custom("Jersey10", size: 24))

                            Text("Age: \(calculateAge(from: birthDate))")
                                .font(.custom("Jersey10", size: 24))

                            // ✏️ Edit Pet Button
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
                                    Text("Edit Pet")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 10)
                                        .background(Color.tailwindPink2)
                                        .cornerRadius(20)
                                        .shadow(radius: 2)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding()
                    } else {
                        // ➕ Add Pet Button (if no pet exists)
                        NavigationButtonView(title: "Add Pet") {
                            selectedTab = "AddPet"
                        }
                    }

                    // 📘 Journal Button
                    NavigationButtonView(title: "Journal") {
                        selectedTab = "Journal"
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant("Home"))
    }
}
