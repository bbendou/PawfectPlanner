//
//  NavigationButtonView.swift
//  PawfectPlanner
//
//  Created by Sarim Faraz on 15/03/2025.
//

import SwiftUI

struct NavigationButtonView: View {
    let title: String
    let action: () -> Void

    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Jersey10", size: 36))
                .foregroundColor(Color.tailwindPink1)
                .frame(width: UIScreen.main.bounds.width < 640 ? 220 : 294,
                       height: UIScreen.main.bounds.width < 640 ? 130 : 176)
                .background(isPressed ? Color.tailwindPink1 : Color.white)
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .pressEvents(onPress: { pressed in
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = pressed
            }
        })
        .accessibility(label: Text(title))
        .accessibility(hint: Text("Tap to \(title.lowercased())"))
    }
}

// Custom button press modifier
struct PressActions: ViewModifier {
    var onPress: (Bool) -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        onPress(true)
                    }
                    .onEnded { _ in
                        onPress(false)
                    }
            )
    }
}

extension View {
    func pressEvents(onPress: @escaping (Bool) -> Void) -> some View {
        modifier(PressActions(onPress: onPress))
    }
}
