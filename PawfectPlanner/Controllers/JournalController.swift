//
//  JournalController.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on [Date].
//

import SwiftUI
import Combine
import FirebaseAuth

class JournalController: ObservableObject {
    @Published var entries: [JournalEntry] = []
    private let journalService = JournalService()

    /// Saves a journal entry with text, an optional image, and a date.
    func saveEntry(_ text: String, image: UIImage?, date: Date) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No current user.")
            return
        }

        if let image = image {
            print("DEBUG: Starting image upload...")
            // Upload the image first, then save the journal entry with its URL.
            journalService.uploadImage(image) { [weak self] imageURL in
                print("DEBUG: Image upload completed. URL: \(imageURL ?? "nil")")
                self?.saveEntryToFirestore(userID: currentUserID, text: text, date: date, imageURL: imageURL)
            }
        } else {
            print("DEBUG: No image to upload")
            // Save the text-only journal entry.
            saveEntryToFirestore(userID: currentUserID, text: text, date: date, imageURL: nil)
        }
    }

    private func saveEntryToFirestore(userID: String, text: String, date: Date, imageURL: String?) {
        print("DEBUG: Saving entry to Firestore with imageURL: \(imageURL ?? "nil")")
        journalService.addJournalEntry(userID: userID, content: text, isPublic: true, timestamp: date, imageURL: imageURL) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to save journal entry: \(error.localizedDescription)")
                } else {
                    print("DEBUG: Journal entry saved successfully with imageURL: \(imageURL ?? "nil")")
                    // Fetch updated entries after saving
                    self?.fetchEntries()
                }
            }
        }
    }

    /// Fetches all journal entries.
    func fetchEntries(completion: ((Error?) -> Void)? = nil) {
        journalService.fetchPublicJournals { [weak self] entries, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to fetch journal entries: \(error.localizedDescription)")
                    completion?(error)
                } else if let entries = entries {
                    print("DEBUG: Fetched \(entries.count) entries")
                    for (index, entry) in entries.enumerated() {
                        print("DEBUG: Entry \(index) imageURL: \(entry.imageURL ?? "nil")")
                    }
                    self?.entries = entries
                    completion?(nil)
                }
            }
        }
    }
}
