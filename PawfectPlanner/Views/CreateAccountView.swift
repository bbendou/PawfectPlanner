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
    @State private var navigateToHome = false
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // App Logo
                Image("2Paws")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                    .padding(.top, 50)

                // Title
                Text("CREATE AN ACCOUNT!")
//                    .font(.custom("Jersey10", size: 36))
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(Color.tailwindBrown3)
                    .padding(.bottom, 10)
                    

                // Name Input Field
                TextField("Name", text: $name)
                    .autocapitalization(.words)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)

                // Email Input Field
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)

                // Password Input Field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)

                // Confirm Password Input Field
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)

                // Sign Up Button
                Button(action: handleSignUp) {
                    Text("Sign Up")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: 100)
                        .padding()
                        .background(Color.tailwindPink2)
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                .padding(.top, 10)
            

                // Already have an account?
                NavigationLink(destination: LoginView()) {
                    Text("Already have an account? Log in here.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .underline()
                }
                .padding(.top, 2)

                Spacer()

                // ✅ Navigation to Home after successful sign-up
                .navigationDestination(isPresented: $navigateToHome) {
                    ContentView() // Navigate to home screen
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("ERROR!"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Firebase Authentication Functions

    /// Handles user sign-up with Firebase Authentication.
    private func handleSignUp() {
        if name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }

        if password != confirmPassword {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }

        // Firebase Authentication - Create Account
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
                showAlert = true
                return
            }

            // ✅ User successfully signed up
            alertMessage = "Account created successfully!"
            showAlert = true
            navigateToHome = true
        }
    }
}

// MARK: - Preview
struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
