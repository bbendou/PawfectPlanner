//
//  HomeView.swift
//  PawfectPlanner
//
//  Created by Sarim Faraz on 15/03/2025.
//

import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: String // This connects with ContentView.swift

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header
                Text("Pawfect Planner")
                    .font(.custom("Jersey10", size: geometry.size.width < 640 ? 32 : 40))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.width < 640 ? 80 : 94)
                    .background(Color.brandBlue)
                    .padding(.bottom, 10)

                // Main Content
                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: 120)

                    // Navigate to Add Pet screen
                    NavigationButtonView(title: "Add Pet") {
                        selectedTab = "AddPet"
                    }

                    // Navigate to Browse Journals screen
                    NavigationButtonView(title: "Browse Journals") {
                        selectedTab = "Journal"
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

// Modify the preview to use a default tab
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant("Home"))
    }
}
