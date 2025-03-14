//
//  Untitled.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 14/03/2025.
//

import SwiftUI

class JournalController: ObservableObject {
    @Published var journalEntries: [(text: String, date: Date)] = [] // ✅ Stores notes with date

    // ✅ Save an entry with date
    func saveEntry(_ entry: String, date: Date) {
        journalEntries.append((text: entry, date: date))
        print("Saved Entry: \(entry) on \(dateFormatted(date))")
    }

    // ✅ Format date for display
    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

