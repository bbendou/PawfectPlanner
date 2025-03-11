//
//  AddImageButton.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 11/03/2025.
//

import SwiftUI

struct AddImageButton: View {
    var action: () -> Void // Function to trigger when tapped
        var body: some View {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(Color.tailwindBlue900) // Corrected color to match navigation bar
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)

                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
            }
            .padding(20) // Padding from screen edges
        }
}

struct AddImageButton_Previews: PreviewProvider {
    static var previews: some View {
        AddImageButton(action: {
            print("Add button tapped!")
        })
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
