//
//  JournalService.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 01/03/2025.
//

import FirebaseFirestore
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
    ///   - videoURL: The URL for an external video (YouTube/Vimeo).
    ///   - completion: A closure returning an error if the operation fails.
    func addJournalEntry(userID: String, content: String, isPublic: Bool, timestamp: Date, imageURL: String?, videoURL: String?, completion: @escaping (Error?) -> Void) {
        let journalData: [String: Any] = [
            "userID": userID,
            "content": content,
            "timestamp": timestamp,
            "isPublic": isPublic,
            "imageURL": imageURL ?? "",
            "videoURL": videoURL ?? ""
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

    /// Converts an image to a Base64 string for storage in Firestore
    /// - Parameters:
    ///   - image: The UIImage to convert
    ///   - completion: A closure returning the Base64 string or nil
    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        // Resize image to reduce storage size
        let maxDimension: CGFloat = 1024
        let scale = min(maxDimension / image.size.width, maxDimension / image.size.height, 1.0)
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Convert to JPEG with reduced quality
        guard let imageData = resizedImage?.jpegData(compressionQuality: 0.5) else {
            print("DEBUG: Failed to convert image to JPEG data")
            completion(nil)
            return
        }

        // Convert to Base64
        let base64String = "data:image/jpeg;base64," + imageData.base64EncodedString()
        print("DEBUG: Successfully converted image to Base64")
        completion(base64String)
    }
}
