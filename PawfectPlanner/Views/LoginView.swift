import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToHome = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // App Logo
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 50)

                // Title
                Text("WELCOME BACK!")
//                    .font(.custom("Jersey10", size: 36))
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(Color.tailwindBrown3)
                    .padding(.bottom, 10)

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

                // Forgot Password
                Button(action: handleForgotPassword) {
                    Text("Forgot Password?")
                        .foregroundColor(.blue)
                        .font(.system(size: 14))
//                        .padding(.top, 5)
                }

                // Login Button
                Button(action: handleLogin) {
                    Text("Login")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: 100)
                        .padding()
                        .background(Color.tailwindPink2)
                        .cornerRadius(20)
                        .padding(.horizontal)
                }
//                .padding(.top, 5)

                // Don't have an account?
                NavigationLink(destination: CreateAccountView()) {
                    Text("Don't have an account? Sign up here.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .underline()
                }
                .padding(.top, 2)

                Spacer()

                // ✅ Corrected Navigation to HomeView after successful login
                .navigationDestination(isPresented: $navigateToHome) {
                    ContentView() // Navigate to home screen
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Firebase Authentication Functions

    /// Handles user login with Firebase Authentication.
    private func handleLogin() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = "Login Failed: \(error.localizedDescription)"
                showAlert = true
                return
            }

            // Login successful, navigate to Home
            alertMessage = "Login Successful!"
            showAlert = true
            navigateToHome = true
        }
    }

    /// Handles password reset functionality.
    private func handleForgotPassword() {
        if email.isEmpty {
            alertMessage = "Please enter your email to reset password."
            showAlert = true
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
            } else {
                alertMessage = "Password reset link sent to \(email)."
            }
            showAlert = true
        }
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

