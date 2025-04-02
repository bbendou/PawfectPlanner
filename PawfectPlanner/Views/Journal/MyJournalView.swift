//
//  MyJournalView.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 02/04/2025.
//

import SwiftUI

struct MyJournalView: View {
    @ObservedObject var journalController: JournalController
    @State private var currentEntryIndex = 0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Top Navigation Bar with Prev/Next for entries
                TopNavBar(
                    onPrev: {
                        // If we're at the first entry, go back to main page
                        if currentEntryIndex == 0 {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            currentEntryIndex -= 1
                        }
                    },
                    onNext: {
                        if currentEntryIndex < journalController.entries.count - 1 {
                            currentEntryIndex += 1
                        }
                    }
                )

                if !journalController.entries.isEmpty {
                    let entry = journalController.entries[currentEntryIndex]

                    // Date & Time display
                    HStack(spacing: 6) {
                        Text(formattedDate(entry.timestamp))
                            .font(.system(size: 16))
                            .foregroundColor(Color.tailwindBlue500)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    }
                    .padding(.top, 8)

                    // Image Display using JournalCard
                    JournalCard(height: 270) {
                        if let imageURL = entry.imageURL, !imageURL.isEmpty, let url = URL(string: imageURL) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 250, height: 250)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 250, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 24))
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 250, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 24))
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image("default_cat")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                    }
                    .frame(width: 327)
                    .padding(.top, 14)

                    // Notes Display
                    VStack(alignment: .leading, spacing: 0) {
                        Text("NOTES")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.tailwindYellow700)
                            .padding(.top, 10)

                        Text(entry.content)
                            .font(.title2)
                            .foregroundColor(.black)
                            .frame(maxWidth: 327, minHeight: 150, maxHeight: 250)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .frame(width: 290)
                    .padding(.horizontal, 28)
                    .padding(.top, 10)
                    .padding(.bottom, 28)
                    .background(Color.tailwindRed100)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)

                    Spacer()
                } else {
                    Text("No journal entries yet")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            journalController.fetchEntries()
        }
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
