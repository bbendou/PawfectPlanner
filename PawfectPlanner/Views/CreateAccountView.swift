//
//  CreateAccountView.swift
//  PawfectPlanner
//
//  Created by Sarim Faraz on 14/03/2025.
//

import SwiftUI
import FirebaseAuth

struct CreateAccountView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToHome = false // ✅ New state variable to navigate to HomeView

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // Background color

            VStack(spacing: 20) {
                // Paw Image Positioned on Top
                Image("LoginPaws") // Ensure this matches your asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200) // Adjust size as needed
                    .padding(.top, 40)

                Text("CREATE YOUR ACCOUNT!")
                    .font(.system(size: 28, weight: .bold))
                    .tracking(0.8)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)

                VStack(spacing: 15) { // Smaller spacing
                    CustomInputField(title: "Name", text: $name, placeholder: "Enter your name")
                    CustomInputField(title: "Email", text: $email, placeholder: "Enter your email", keyboardType: .emailAddress)
                    CustomInputField(title: "Password", text: $password, placeholder: "Enter your password", isSecure: true)
                    CustomInputField(title: "Re-enter Password", text: $confirmPassword, placeholder: "Confirm your password", isSecure: true)

                    Button(action: handleSubmit) {
                        Text("Submit")
                            .font(.system(size: 22, weight: .bold)) // Adjust button text size
                            .foregroundColor(Color.customGreen)
                            .frame(width: 193, height: 50)
                            .background(Color.customBackground)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.top, 20)
                }
                .frame(maxWidth: 329)
            }
            .padding(20)
            .background(Color.white)

            // ✅ Navigation to ContentView when navigateToHome becomes true
            NavigationLink(
                destination: ContentView(),
                isActive: $navigateToHome
            ) { EmptyView() }
            .hidden()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Message"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertMessage == "Account created successfully! Redirecting to Home..." {
                        navigateToHome = true // ✅ Navigate to ContentView
                    }
                }
            )
        }
    }

    private func handleSubmit() {
        if name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }

        if password != confirmPassword {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }

        // Firebase Authentication - Sign Up
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
                showAlert = true
                return
            }

            // ✅ User successfully signed up
            alertMessage = "Account created successfully! Redirecting to Home..."
            showAlert = true
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}

