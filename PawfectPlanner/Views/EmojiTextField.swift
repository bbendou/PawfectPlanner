//
//  EmojiTextField.swift
//  PawfectPlanner
//
//  Created by jullia andrei on 15/03/2025.
//


import SwiftUI
import UIKit

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField

        init(parent: EmojiTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let scalar = string.unicodeScalars.first else { return false }
            return scalar.properties.isEmoji // Allow only emojis
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            if let text = textField.text, text.count > 1 {
                textField.text = String(text.prefix(1)) // Keep only the first emoji
            }
            parent.text = textField.text ?? ""
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.allowsEditingTextAttributes = false
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}
