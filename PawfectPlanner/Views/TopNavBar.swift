//
//  TopNavBar.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 11/03/2025.
//

import SwiftUI

struct TopNavBar: View {
    var onPrev: () -> Void // Action for "Prev"
    var onNext: () -> Void // Action for "Next"

    var body: some View {
        HStack {
            Button(action: onPrev) {
                Text("< Prev")
                    .font(.title2)
                    .fontWeight(.regular)
                    .foregroundColor(.white)
            }

            Spacer()

            Button(action: onNext) {
                Text("Next >")
                    .font(.title2)
                    .fontWeight(.regular)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 48)
        .padding(.bottom, 28)
        .frame(maxWidth: .infinity)
        .background(Color.tailwindBlue900)
    }
}

struct TopNavBar_Previews: PreviewProvider {
    static var previews: some View {
        TopNavBar(
            onPrev: { print("Prev tapped") },
            onNext: { print("Next tapped") }
        )
        .previewLayout(.sizeThatFits)
    }
}
