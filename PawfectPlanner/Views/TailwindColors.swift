import SwiftUI

extension Color {
    init(hexValue: String) {
        let hex = hexValue.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let red, green, blue, alpha: Double
        switch hex.count {
        case 6: // RGB (No Alpha)
            red = Double((int >> 16) & 0xFF) / 255.0
            green = Double((int >> 8) & 0xFF) / 255.0
            blue = Double(int & 0xFF) / 255.0
            alpha = 1.0
        case 8: // RGBA
            red = Double((int >> 24) & 0xFF) / 255.0
            green = Double((int >> 16) & 0xFF) / 255.0
            blue = Double((int >> 8) & 0xFF) / 255.0
            alpha = Double(int & 0xFF) / 255.0
        default:
            red = 1.0
            green = 1.0
            blue = 1.0
            alpha = 1.0
        }
        
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    static let lightBrown1 = Color(hexValue: "#ad7041")
    static let lightBrown2 = Color(hexValue: "#b57e54")
    static let lightBrown3 = Color(hexValue: "#bd8d67")
    static let lightBrown4 = Color(hexValue: "#c69b7a")
    static let lightBrown5 = Color(hexValue: "#cea98d")
    
    static let lightBrown6 = Color(hexValue: "#efe2d2")
    
    static let logolightBrown = Color(hexValue: "#d6b68f")
    static let brown1 = Color(hexValue: "#684327")
    
    static let darkBrown1 = Color(hexValue: "#4b3129")
    static let darkBrown2 = Color(hexValue: "32211b")
    
    static let lightpink1 = Color(hexValue: "#fae8e0")
    static let pink1 = Color(hexValue: "#f9a388")
    static let pink2 = Color(hexValue: "#fab5a0")
    static let pink3 = Color(hexValue: "#fbc8b8")
    
    static let blue1 = Color(hexValue: "#335288")
    static let blue2 = Color(hexValue: "#5c75a0")
    static let blue3 = Color(hexValue: "#8597b8")
    static let blue4 = Color(hexValue: "#adbacf")
    
    static let darkblue1 = Color(hexValue: "#142136")
    static let darkblue2 = Color(hexValue: "#0a101b")

    
    // Blue colors
    static let tailwindBlue900 = Color(red: 51/255, green: 82/255, blue: 136/255)
    static let tailwindBlue500 = Color(red: 59/255, green: 130/255, blue: 246/255)

    // Red colors
    static let tailwindRed100 = Color(red: 254/255, green: 226/255, blue: 226/255)

    // Yellow colors
    static let tailwindYellow700 = Color(red: 161/255, green: 98/255, blue: 7/255)

    // Zinc/Gray colors
    static let tailwindZinc100 = Color(red: 244/255, green: 244/255, blue: 245/255)
    
    // Pink colors
    static let tailwindPink1 = Color(red: 253/255, green: 221/255, blue: 212/255)
    static let tailwindPink2 = Color(red: 249/255, green: 163/255, blue: 140/255)

    
    // Brown colors
    static let tailwindBrown1 = Color(red: 219/255, green: 203/255, blue: 187/255)
    static let tailwindBrown2 = Color(red: 214/255, green: 182/255, blue: 143/255)
    static let tailwindBrown3 = Color(red: 94/255, green: 58/255, blue: 31/255)
    





}
