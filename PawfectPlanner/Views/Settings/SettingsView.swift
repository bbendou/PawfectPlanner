//
//  SettingsView 2.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 16/03/2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SettingsView: View {
    @State private var showAddAnotherPet = false
    @State private var showReviewModal = false
    @State private var reviewRating = 5
    @State private var reviewText = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var navigateToLogin = false
    
    // Bug Button
    @State private var showBugModal = false
    @State private var bugReportText = ""
    
    // Accesibility Button
    @State private var showAccessibilityModal = false
    @EnvironmentObject var fontSettings: FontSettings
    
    // Edit Profile Button
    @State private var userName: String = "Your Name"
    @State private var userEmail: String = "email@example.com"


    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                // Title Bar
                Text("Settings")
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.tailwindBlue900)
                    .foregroundColor(.white)

                Spacer()

                // User Profile Section
                HStack(alignment: .center) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(userName)
                            .font(.system(size: fontSettings.fontSize, weight: .semibold))

                        Text(userEmail)
                            .font(.system(size: fontSettings.fontSize - 2))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    NavigationLink(destination: EditProfileView()) {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 12, height: 20)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
                .onAppear {
                    fetchUserProfile()
                }

                // Settings Options
                Group {
                    NavigationLink(destination: AddAnotherPetView(), isActive: $showAddAnotherPet) {
                        EmptyView()
                    }

                    settingsButton(icon: "plus.circle", label: "Add a pet") {
                        showAddAnotherPet = true
                    }                                .font(.system(size: fontSettings.fontSize))


                    NavigationLink(destination: AccessibilitySettingsView()) {
                        HStack {
                            Image(systemName: "accessibility")
                                .frame(width: 30)
                            Text("Accessibility")
                                .font(.system(size: fontSettings.fontSize))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    }

//                    settingsButton(icon: "square.and.pencil", label: "App Customization") {
//                        // Customization page
//                    }
                    settingsButton(icon: "exclamationmark.triangle", label: "Report a Bug") {
                        showBugModal = true
                    }
                    .sheet(isPresented: $showBugModal) {
                        VStack(spacing: 20) {
                            Text("Report a Bug")
                                .font(.title)
                                .bold()

                            Text("Describe what went wrong:")
                                .font(.system(size: fontSettings.fontSize))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            TextEditor(text: $bugReportText)
                                .frame(height: 150)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))

                            Button("Submit Bug Report") {
                                sendBugReportEmail()
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)

                            Spacer()
                        }
                        .padding()
                    }
                    settingsButton(icon: "star", label: "Review App") {
                        showReviewModal = true
                    }

                }

                Spacer()

                // Logout Button
                Button(action: handleLogout) {
                    Text("Log Out")
                        .font(.system(size: fontSettings.fontSize))
                        .foregroundColor(.white)
                        .frame(maxWidth: 100)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.bottom)

                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .sheet(isPresented: $showReviewModal) {
            VStack(spacing: 20) {
                Text("Rate Our App")
                    .font(.title)
                    .bold()

                // Rating stars
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= reviewRating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .onTapGesture {
                                reviewRating = index
                            }
                    }
                }

                TextEditor(text: $reviewText)
                    .frame(height: 120)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))

                // Submit button
                Button("Submit Review") {
                    sendReviewToFirebase()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.tailwindBlue500)
                .cornerRadius(10)

                Spacer()
                


            }
            .padding()
        }
    }
    
    func fetchUserProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.userName = data?["username"] as? String ?? "No Username"
                self.userEmail = data?["email"] as? String ?? "No Email"
            } else {
                print("User document not found: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    // MARK: - Reusable Button
    func settingsButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 30)
                Text(label)
                    .font(.system(size: fontSettings.fontSize))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .foregroundColor(.black)
            .padding(.horizontal)
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
    
    // MARK - Review
    func sendReviewToFirebase() {
        let db = Firestore.firestore()
        let reviewData: [String: Any] = [
            "rating": reviewRating,
            "feedback": reviewText,
            "timestamp": Timestamp(date: Date())
        ]

        db.collection("app_reviews").addDocument(data: reviewData) { error in
            if let error = error {
                alertMessage = "Error submitting review: \(error.localizedDescription)"
                showAlert = true
            } else {
                alertMessage = "Thank you for your feedback!"
                showAlert = true
                showReviewModal = false
                reviewText = ""
                reviewRating = 5
            }
        }
    }
    
    func sendBugReportEmail() {
        let emails = ["jmontejo@andrew.cmu.edu"]
        let emailList = emails.joined(separator: ",")
        
        let subject = "Bug Report - PawfectPlanner"
        let body = """
        Bug Description:
        \(bugReportText)
        """

        let formatted = "mailto:\(emailList)?subject=\(subject)&body=\(body)"
        if let encoded = formatted.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encoded) {
            UIApplication.shared.open(url)
            showBugModal = false
            bugReportText = ""
        }
    }

}






// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(FontSettings())
    }
}

