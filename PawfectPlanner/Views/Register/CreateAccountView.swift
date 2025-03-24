//
//  CreateAccountView.swift
//  PawfectPlanner
//
//  Created by Sarim Faraz on 14/03/2025.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CreateAccountView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToHome = false
    @State private var navigateToLogin = false
    @State private var username: String = ""
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.tailwindBrown1
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    // App Logo
                    Image("LogoWord")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 200)
                        .padding(.top, 20)
                    
                    // Title
                    Text("CREATE ACCOUNT")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(Color.tailwindBrown3)
                        .padding(.bottom, 0)
                    
                    
                    // Username
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
                        .padding(.horizontal)
                        .frame(width: 350)

                    
                    // Email Input Field
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
                        .padding(.horizontal)
                        .frame(width: 350)

                    
                    
                    // Password Input Field
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
                        .padding(.horizontal)
                        .frame(width: 350)

                    
                    // Confirm Password Input Field
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
                        .padding(.horizontal)
                        .frame(width: 350)

                    
                    // Sign Up Button
                    Button(action: handleSignUp) {
                        Text("Register")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: 150)
                            .padding()
                            .background(Color.blue1)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.top, 10)
                    
                    
                    // Already have an account?
                    NavigationLink(destination: LoginView()) {
                        Text("Already have an account? Log in here.")
                            .font(.system(size: 14))
                            .foregroundColor(.brown1)
                            .underline()
                    }
                    .padding(.top, 2)
                    
                    Spacer()
                    
                        .navigationDestination(isPresented: $navigateToHome) {
                            ContentView() // Navigate to home screen
                        }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("ERROR!"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    
    // MARK: - Firebase Authentication Functions
    
    private func handleSignUp() {
        if username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        if password != confirmPassword {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .whereField("email", isEqualTo: email)
            .getDocuments { emailSnapshot, emailError in
                if let emailError = emailError {
                    alertMessage = "Error checking email: \(emailError.localizedDescription)"
                    showAlert = true
                    return
                }
                
                if let emailSnapshot = emailSnapshot, !emailSnapshot.documents.isEmpty {
                    alertMessage = "Email is already in use."
                    showAlert = true
                    return
                }
                
                db.collection("users")
                    .whereField("username", isEqualTo: username)
                    .getDocuments { usernameSnapshot, usernameError in
                        if let usernameError = usernameError {
                            alertMessage = "Error checking username: \(usernameError.localizedDescription)"
                            showAlert = true
                            return
                        }
                        
                        if let usernameSnapshot = usernameSnapshot, !usernameSnapshot.documents.isEmpty {
                            alertMessage = "Username is already taken."
                            showAlert = true
                            return
                        }
                        
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                alertMessage = "Error: \(error.localizedDescription)"
                                showAlert = true
                                return
                            }
                            
                            guard let userID = authResult?.user.uid else {
                                alertMessage = "Failed to retrieve user ID."
                                showAlert = true
                                return
                            }
                            
                            let userRef = db.collection("users").document(userID)
                            userRef.setData([
                                "username": username,
                                "email": email,
                                "createdAt": Timestamp(date: Date())
                            ]) { error in
                                if let error = error {
                                    alertMessage = "Firestore Error: \(error.localizedDescription)"
                                } else {
                                    alertMessage = "Account created successfully!"
                                    navigateToHome = true
                                }
                                showAlert = true
                            }
                        }
                    }
            }
    }
}
    
    // MARK: - Preview
    struct CreateAccountView_Previews: PreviewProvider {
        static var previews: some View {
            CreateAccountView()
        }
    }

