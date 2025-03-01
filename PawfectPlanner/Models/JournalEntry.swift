//
//  JournalEntry.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 01/03/2025.
//

import FirebaseFirestoreSwift

/// Represents a pet journal entry.
struct JournalEntry: Codable, Identifiable {
    @DocumentID var id: String?
    var userID: String
    var content: String
    var timestamp: Date
    var isPublic: Bool
}
