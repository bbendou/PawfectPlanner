//
//  JournalService.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 01/03/2025.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

/// Handles Firestore operations for pet journals.
struct JournalService {
    
    private let db = Firestore.firestore()

    /// Saves a journal entry to Firestore.
    /// - Parameters:
    ///   - userID: The ID of the pet owner.
    ///   - content: The journal entry content.
    ///   - isPublic: Whether the journal is publicly visible.
    ///   - completion: A closure returning an error if the operation fails.
    func addJournalEntry(userID: String, content: String, isPublic: Bool, completion: @escaping (Error?) -> Void) {
        let journalData: [String: Any] = [
            "userID": userID,
            "content": content,
            "timestamp": FieldValue.serverTimestamp(),
            "isPublic": isPublic
        ]
        
        db.collection("journals").addDocument(data: journalData) { error in
            completion(error)
        }
    }

    /// Fetches all public journal entries.
    /// - Parameter completion: A closure returning an array of journals or an error.
    func fetchPublicJournals(completion: @escaping ([JournalEntry]?, Error?) -> Void) {
        db.collection("journals").whereField("isPublic", isEqualTo: true)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion(nil, error)
                    return
                }
                
                let journals = documents.compactMap { doc -> JournalEntry? in
                    try? doc.data(as: JournalEntry.self)
                }
                completion(journals, nil)
            }
    }
}
