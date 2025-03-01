//
//  User.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 01/03/2025.
//

import FirebaseFirestoreSwift

/// Represents a user profile.
struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var isPetOwner: Bool
}
