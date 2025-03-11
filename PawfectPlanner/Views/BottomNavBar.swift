//
//  BottomNavBar.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 11/03/2025.
//
import SwiftUI

struct BottomNavBar: View {
    var body: some View {
        HStack(spacing: 0) {
            Spacer()

            // Home Icon
            NavBarItem(icon: "house.fill")

            Spacer()

            // Calendar Icon
            NavBarItem(icon: "calendar")

            Spacer()

            // Journal Icon (Using NotebookIcon component)
            NotebookIcon(isInverted: true) // Uses the white version
                .frame(width: 24, height: 28)
                .scaleEffect(0.3)
                .background(Color.white.cornerRadius(6))
                .frame(width: 40, height: 40)


            Spacer()

            // Settings Icon
            NavBarItem(icon: "gearshape.fill")

            Spacer()
        }
        .frame(height: 73)
        .background(Color.tailwindBlue900)
    }
}

struct NavBarItem: View {
    let icon: String

    var body: some View {
        Image(systemName: icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .foregroundColor(.white)
            .frame(width: 54, height: 54)
    }
}

struct BottomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBar()
            .previewLayout(.sizeThatFits)
    }
}
