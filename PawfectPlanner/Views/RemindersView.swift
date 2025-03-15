//
//  RemindersView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 14/03/2025.
//

import SwiftUI

struct RemindersView: View {
    var body: some View {
        VStack {
            // Title Bar
            Rectangle()
                .fill(Color.blue)
                .frame(height: 50)
                .overlay(
                    Text("REMINDERS")
                        .font(.custom("PixelFont", size: 24)) // Use your font
                        .foregroundColor(.white)
                )
            
            Spacer()
            
            // Bell Image
            Image(systemName: "bell.fill") // Replace with your custom bell image
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.brown) // Adjust color as needed

            // No Reminders Message
            Text("NO REMINDERS SET!")
                .font(.custom("PixelFont", size: 20)) // Use your font
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.top, 10)

            // Instruction to Add Reminder
            VStack {
                Text("Click here to add your first reminder!")
                    .font(.custom("PixelFont", size: 16)) // Use your font
                    .foregroundColor(.brown)
                
                Image(systemName: "arrow.down") // A small arrow pointing to the button
                    .foregroundColor(.brown)
            }
            .padding(.top, 10)
            
            // Floating Action Button
            Button(action: {
                // Action for adding reminders
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding()
                    .background(Color.pink)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            }
            .padding(.top, 10)

            Spacer()
            
        }
        .edgesIgnoringSafeArea(.bottom) // Extends the blue navigation bar
    }
}


struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
    }
}
