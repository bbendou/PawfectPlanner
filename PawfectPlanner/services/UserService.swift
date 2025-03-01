//
//  UserService.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 01/03/2025.
//

import FirebaseFirestore

/// Handles Firestore operations for user profiles.
struct UserService {
    
    private let db = Firestore.firestore()

    /// Fetches a user profile.
    /// - Parameters:
    ///   - userID: The user's ID.
    ///   - completion: A closure returning user data or an error.
    func fetchUserProfile(userID: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                completion(document.data(), nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
