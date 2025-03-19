//
//  RegisterView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 19/03/2025.
//


import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isRegistered = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Register")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Full Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button(action: registerUser) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .alert(isPresented: $isRegistered) {
            Alert(title: Text("Success"), message: Text("User Registered Successfully!"), dismissButton: .default(Text("OK")))
        }
    }

    func registerUser() {
        guard !name.isEmpty, !email.isEmpty else {
            errorMessage = "All fields are required."
            return
        }

        // ✅ Generate a unique user ID
        let userID = UUID().uuidString

        FirestoreService.shared.addUser(userID: userID, name: name, email: email) { success, error in
            if success {
                isRegistered = true
                errorMessage = nil
            } else {
                errorMessage = error?.localizedDescription ?? "Failed to register user."
            }
        }
    }
}
