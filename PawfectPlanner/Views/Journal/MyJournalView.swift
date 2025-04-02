//
//  MyJournalView.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 02/04/2025.
//

import SwiftUI

struct MyJournalView: View {
    @ObservedObject var journalController: JournalController

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(journalController.entries) { entry in
                    JournalEntryCard(entry: entry)
                }
            }
            .padding()
        }
        .navigationTitle("My Journal")
        .onAppear {
            journalController.fetchEntries()
        }
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry

    var body: some View {
        VStack(spacing: 16) {
            // Display the entry's date and time in a formatted style
            Text(formattedDate(entry.timestamp))
                .font(.headline)
                .foregroundColor(.gray)
            
            // Display the image if available
            if let imageURL = entry.imageURL, !imageURL.isEmpty, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            // Display the journal note content in a read-only Text view
            Text(entry.content)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .padding()
        .background(Color.tailwindRed100)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct MyJournalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MyJournalView(journalController: JournalController())
        }
    }
}
