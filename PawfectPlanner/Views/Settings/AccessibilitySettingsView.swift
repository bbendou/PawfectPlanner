//
//  AccessibilitySettingsView.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 14/04/2025.
//

import SwiftUI

struct AccessibilitySettingsView: View {
    @EnvironmentObject var fontSettings: FontSettings

    var body: some View {
        VStack(spacing: 25) {
            Text("Accessibility Options")
                .font(.system(size: 30, weight: .bold))
                .padding(.top, 30)
                .foregroundColor(Color.tailwindBlue900)


            Text("Select your preferred font size:")
                .font(.system(size: fontSettings.fontSize))

            // Font Size Options
            HStack(spacing: 15) {
                fontSizeOption(label: "Small", size: 14)
                fontSizeOption(label: "Medium", size: 18)
                fontSizeOption(label: "Large", size: 24)
            }

            Text("This is a preview of your selected size.")
                .font(.system(size: fontSettings.fontSize))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            Spacer()
        }
        .padding()
    }
    
        

    // Helper to show font size option buttons
    @ViewBuilder
    private func fontSizeOption(label: String, size: CGFloat) -> some View {
        Button(action: {
            fontSettings.fontSize = size
        }) {
            Text(label)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(fontSettings.fontSize == size ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(fontSettings.fontSize == size ? .white : .black)
                .cornerRadius(12)
        }
    }
}

struct AccessibilitySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccessibilitySettingsView()
            .environmentObject(FontSettings())
    }
}
