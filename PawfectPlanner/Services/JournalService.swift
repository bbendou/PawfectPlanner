//
//  JournalService.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 01/03/2025.
//

import FirebaseFirestore
import FirebaseStorage
import UIKit

/// Handles Firestore operations for pet journals.
struct JournalService {

    private let db = Firestore.firestore()

    /// Saves a journal entry to Firestore.
    /// - Parameters:
    ///   - userID: The ID of the pet owner.
    ///   - content: The journal entry content.
    ///   - isPublic: Whether the journal is publicly visible.
    ///   - timestamp: The user-selected date for the entry.
    ///   - imageURL: The URL for the uploaded image.
    ///   - completion: A closure returning an error if the operation fails.
    func addJournalEntry(userID: String, content: String, isPublic: Bool, timestamp: Date, imageURL: String?, completion: @escaping (Error?) -> Void) {
        let journalData: [String: Any] = [
            "userID": userID,
            "content": content,
            "timestamp": timestamp,
            "isPublic": isPublic,
            "imageURL": imageURL ?? ""
        ]

        db.collection("journals").addDocument(data: journalData) { error in
            completion(error)
        }
    }

    /// Fetches all public journal entries.
    /// - Parameter completion: A closure returning an array of journals or an error.
    func fetchPublicJournals(completion: @escaping ([JournalEntry]?, Error?) -> Void) {
        db.collection("journals")
            .whereField("isPublic", isEqualTo: true)
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

    /// Uploads an image to Firebase Storage and returns its download URL.
    /// - Parameters:
    ///   - image: The UIImage to upload.
    ///   - completion: A closure returning the image URL string or nil.
    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        let storageRef = Storage.storage().reference().child("journalImages/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard error == nil else {
                print("Image upload failed: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(url.absoluteString)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
