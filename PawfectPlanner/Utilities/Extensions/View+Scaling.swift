//
//  View+Scaling.swift
//  PawfectPlanner
//
//  Created by Sarim Faraz on 14/03/2025.
//

import SwiftUI

extension View {
    func scaleOnPress() -> some View {
        self.modifier(ScaleButtonModifier())
    }
}

struct ScaleButtonModifier: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 1.05 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
            .onTapGesture {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isPressed = false
                }
            }
    }
}
