//
//  AddButton.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 11/03/2025.
//

import SwiftUI

struct NewEntryButton: View {
    @EnvironmentObject var fontSettings: FontSettings

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "pencil")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 54, height: 56)
                .foregroundColor(.black)

            Text("Add New Entry")
                .font(.system(size: fontSettings.fontSize))
                .foregroundColor(Color.tailwindYellow700)
        }
        .padding(.horizontal, 20)
        .frame(width: 350, height: 129)
        .background(Color.tailwindRed100)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
}

struct NewEntryButton_Previews: PreviewProvider {
    static var previews: some View {
        NewEntryButton()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
