//
//  SettingsView 2.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 16/03/2025.
//


//
//  SettingsView.swift
//  PawfectPlanner
//
//  Created by Jullia Andrei on 16/03/2025.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @State private var navigateToLogin = false // Controls navigation to login screen
    @State private var showAlert = false // Controls alert visibility
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            VStack {
                // Title Bar
                Text("Settings")
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.tailwindBlue900)
                    .foregroundColor(.white)

                    Spacer()

                // Logout Button
                Button(action: handleLogout) {
                    Text("Log Out")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: 70)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 30)

                Spacer()

                // ✅ Navigation to Login Page after logout
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Logout Function
    private func handleLogout() {
        do {
            try Auth.auth().signOut()
            navigateToLogin = true
        } catch let error {
            alertMessage = "Error logging out: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
