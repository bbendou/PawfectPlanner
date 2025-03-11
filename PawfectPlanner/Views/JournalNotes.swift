//
//  JournalNotes.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 11/03/2025.
//

import SwiftUI

struct JournalNotes: View {
    @Binding var noteText: String

    var body: some View {
        JournalCard(height: 350) {
            VStack(spacing: 0) {
                // "NOTES" Title
                Text("NOTES")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.tailwindYellow700)
                    .padding(.top, 10) // Reduced top padding

                // White note area inside pink JournalCard
                VStack {
                    Text(noteText)
                        .font(.title2)
                        .lineSpacing(4)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(16) // Padding inside the white area
                }
                .frame(width: 280, height: 260) // Slightly larger height for a better fit
                .background(Color.white)
                .cornerRadius(16) // Rounded corners
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                .padding(.top, 4) // Reduced space between "NOTES" and white area
            }
            .padding(.vertical, 12) // Reduced overall vertical padding
        }
        .frame(width: 327) // Ensuring it remains properly centered
        .padding(.top, 28)
    }
}

struct JournalNotes_Previews: PreviewProvider {
    static var previews: some View {
        JournalNotes(noteText: .constant("Sample journal entry"))
    }
}
