//
//  Color+Custom.swift
//  PawfectPlanner
//
//  Created by Sarim Faraz on 14/03/2025.
//

import SwiftUI

extension Color {
    static let primaryGreen = Color(hex: "007848")
    static let buttonBackground = Color(hex: "FAE7E0")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
    
    static let customBackground = Color(red: 250/255, green: 231/255, blue: 224/255) // #FAE7E0
    static let customGreen = Color(red: 0/255, green: 120/255, blue: 72/255) // #007848
    static let brandBlue = Color(red: 51/255, green: 82/255, blue: 136/255)
    static let brandPeach = Color(red: 250/255, green: 231/255, blue: 224/255)
    static let brandPeachHover = Color(red: 248/255, green: 213/255, blue: 200/255)
    
}
