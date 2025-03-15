//
//  HomeView.swift
//  PawfectPlanner
//
//  Created by Sarim Faraz on 15/03/2025.
//

import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: String // ✅ To allow navigation
    @State private var petName: String?
    @State private var petBreed: String?
    @State private var petBirthDate: Date?
    @State private var petImage: UIImage?

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // ✅ Fixed Header Position (Modeled After Original)
                Text("Pawfect Planner")
                    .font(.custom("Jersey10", size: geometry.size.width < 640 ? 32 : 40))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.width < 640 ? 80 : 94)
                    .background(Color.brandBlue)
                    .padding(.bottom, 10)

                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: 120)

                    if let name = petName, let breed = petBreed, let birthDate = petBirthDate {
                        // ✅ Show Pet Details if Available
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
                        }
                        .padding()
                    } else {
                        // ✅ Show Add Pet Button if No Pet Data
                        NavigationButtonView(title: "Add Pet") {
                            selectedTab = "AddPet"
                        }
                    }

                    // ✅ Browse Journals Button
                    NavigationButtonView(title: "Browse Journals") {
                        selectedTab = "Journal"
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
            .onAppear(perform: loadPetData) // ✅ Load pet details when screen appears
            .edgesIgnoringSafeArea(.bottom)
        }
    }

    // ✅ Function to Load Pet Data from UserDefaults
    private func loadPetData() {
        if let savedData = UserDefaults.standard.dictionary(forKey: "petDetails") {
            petName = savedData["name"] as? String
            petBreed = savedData["breed"] as? String

            // ✅ Fix Date Retrieval (Convert String Back to Date)
            if let birthDateString = savedData["birthDate"] as? String,
               let birthDate = ISO8601DateFormatter().date(from: birthDateString) {
                petBirthDate = birthDate
            }
        }

        // ✅ Load Pet Image If Available
        if let imageData = UserDefaults.standard.data(forKey: "petImage"),
           let image = UIImage(data: imageData) {
            petImage = image
        }
    }

    // ✅ Function to Calculate Pet Age
    private func calculateAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year ?? 0
    }
}

// Modify the preview to use a default tab
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant("Home"))
    }
}
