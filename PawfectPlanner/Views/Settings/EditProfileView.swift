//
//  EditProfileView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 14/04/2025.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI


struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var fontSettings: FontSettings

    @State private var username = ""
    @State private var email = ""
    @State private var newPassword = ""
    @State private var currentPassword = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Form {
            Section(header: Text("User Info")) {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
            }

            Section(header: Text("Change Password")) {
                SecureField("New Password", text: $newPassword)

            }
            
            Section(header: Text("Enter current Password for confirmation")) {
                SecureField("Current Password (to confirm)", text: $currentPassword)
            }
            Button("Update Profile") {
                updateProfile()
            }
            .foregroundColor(.blue)

            Button("Forgot Password?") {
                sendPasswordReset()
            }
            .foregroundColor(.red)
        }
        .navigationTitle("Edit Profile")
        .onAppear(perform: loadCurrentUser)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func loadCurrentUser() {
        guard let user = Auth.auth().currentUser else { return }
        email = user.email ?? ""

        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { document, _ in
            if let data = document?.data() {
                DispatchQueue.main.async {
                    self.username = data["username"] as? String ?? ""
                }
            }
        }
    }


    func updateProfile() {
        guard let user = Auth.auth().currentUser, !currentPassword.isEmpty else {
            alertMessage = "Please enter your current password to confirm."
            showAlert = true
            return
        }

        // Re-authenticate the user
        let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: currentPassword)

        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                alertMessage = "Reauthentication failed: \(error.localizedDescription)"
                showAlert = true
                return
            }

            if user.email != email {
                user.updateEmail(to: email) { error in
                    if let error = error {
                        alertMessage = "Failed to update email: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
            }

            if !newPassword.isEmpty {
                user.updatePassword(to: newPassword) { error in
                    if let error = error {
                        alertMessage = "Failed to update password: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
            }

            let db = Firestore.firestore()
            db.collection("users").document(user.uid).updateData(["username": username]) { error in
                if let error = error {
                    alertMessage = "Failed to update username: \(error.localizedDescription)"
                } else {
                    alertMessage = "Profile updated successfully!"
                }
                showAlert = true
            }
        }
    }

    func sendPasswordReset() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            alertMessage = error == nil
                ? "Password reset email sent!"
                : "Failed to send reset email: \(error!.localizedDescription)"
            showAlert = true
        }
    }
}
