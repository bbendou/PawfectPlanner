//
//  FirestoreService.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 19/03/2025.
//


import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()  // Singleton instance
    private let db = Firestore.firestore()

    private init() {}

    // ✅ Add a new user to Firestore
    func addUser(userID: String, name: String, email: String, completion: @escaping (Bool, Error?) -> Void) {
        let userRef = db.collection("users").document(userID)

        userRef.setData([
            "name": name,
            "email": email
        ]) { error in
            if let error = error {
                print("❌ Error adding user: \(error)")
                completion(false, error)
            } else {
                print("✅ User added successfully!")
                completion(true, nil)
            }
        }
    }
}
