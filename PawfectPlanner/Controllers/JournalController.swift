//
//  Untitled.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 14/03/2025.
//

import Foundation

class JournalController: ObservableObject {
    @Published var journalEntries: [String] = [] // This can later be a model object instead of String

    // Function to save an entry
    func saveEntry(_ entry: String) {
        journalEntries.append(entry) // Save in memory (Replace with actual storage logic)
        print("Entry saved: \(entry)")
    }
}
