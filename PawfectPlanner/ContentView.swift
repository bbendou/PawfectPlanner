//
//  ContentView.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 01/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: String = "Home" // Default tab
    
    var body: some View {
        VStack(spacing: 0) {
            // Display the selected view
            if selectedTab == "Home" {
                HomeView(selectedTab: $selectedTab)
            } else if selectedTab == "Reminders" {
                RemindersView()
            } else if selectedTab == "Journal" {
                JournalHomeView()
            } else if selectedTab == "Settings" {
                SettingsView()
            }
            
            // Bottom Navigation Bar
            HStack {
                Spacer()
                Button(action: { selectedTab = "Home" }) {
                    Image(systemName: "house.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundColor(selectedTab == "Home" ? Color.tailwindPink1 : .white)
                }
                Spacer()
                Spacer()
                Button(action: { selectedTab = "Reminders" }) {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundColor(selectedTab == "Reminders" ? Color.tailwindPink1 : .white)
                }
                Spacer()
                Spacer()
                Button(action: { selectedTab = "Journal" }) {
                    Image(systemName: "book.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundColor(selectedTab == "Journal" ? Color.tailwindPink1 : .white)
                }
                Spacer()
                Spacer()
                Button(action: { selectedTab = "Settings" }) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundColor(selectedTab == "Settings" ? Color.tailwindPink1 : .white)
                }
                Spacer()
            }
            .padding(.bottom, 25)
            .padding(.top, 20)
            .background(Color.tailwindBlue900)
        }
        .edgesIgnoringSafeArea(.bottom)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .edgesIgnoringSafeArea(.bottom) // Extend background to bottom edge
    }
}


#Preview {
    ContentView()
}

