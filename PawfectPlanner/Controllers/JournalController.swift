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
            // Upload the image first, then save the journal entry with its URL.
            journalService.uploadImage(image) { [weak self] imageURL in
                self?.saveEntryToFirestore(userID: currentUserID, text: text, date: date, imageURL: imageURL)
            }
        } else {
            // Save the text-only journal entry.
            saveEntryToFirestore(userID: currentUserID, text: text, date: date, imageURL: nil)
        }
    }

    private func saveEntryToFirestore(userID: String, text: String, date: Date, imageURL: String?) {
        journalService.addJournalEntry(userID: userID, content: text, isPublic: true, timestamp: date, imageURL: imageURL) { [weak self] error in
            if let error = error {
                print("Failed to save journal entry: \(error.localizedDescription)")
            } else {
                print("Journal entry saved successfully.")
                // Optionally, update your local entries list after saving.
                self?.fetchEntries()
            }
        }
    }

    /// Fetches all public journal entries.
    func fetchEntries() {
        journalService.fetchPublicJournals { [weak self] entries, error in
            if let error = error {
                print("Failed to fetch journal entries: \(error.localizedDescription)")
            } else if let entries = entries {
                DispatchQueue.main.async {
                    self?.entries = entries
                }
            }
        }
    }
}
