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
                self.username = data["username"] as? String ?? ""
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
        let credential = EmailAuthProvider.credential(withEmail:
