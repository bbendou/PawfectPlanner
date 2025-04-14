import SwiftUI

struct NotebookIcon: View {
    // Accept colors instead of isInverted flag
    var primaryColor: Color = Color.blue // Default primary color
    var secondaryColor: Color = Color.gray.opacity(0.2) // Default secondary color
    var bindingColor: Color = Color.white // Default binding color
    var linesColor: Color = Color.black // Default lines color

    // Define a constant color for the paper/lines background
    private let paperColor = Color.white

    var body: some View {
        ZStack {
            // Main notebook body
            Rectangle()
                .fill(primaryColor) // Use primary color
                .border(Color.black, width: 1)
                .frame(width: 99, height: 133)

            // Notebook content
            ZStack {
                // Lines container - Use the fixed paperColor
                Rectangle()
                    .fill(paperColor) // <-- Changed from secondaryColor
                    .border(Color.black, width: 1)
                    .frame(width: 51, height: 27)
                    .offset(x: 0, y: -43.5)

                // Lines inside container
                VStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { _ in
                        Rectangle()
                            .fill(linesColor) // Use lines color
                            .frame(width: 30, height: 1)
                    }
                }
                .offset(x: 0, y: -43.5)

                // Binding holes
                VStack(spacing: 10) {
                    ForEach(0..<8, id: \.self) { _ in
                        Rectangle()
                            .fill(bindingColor) // Use binding color
                            .border(Color.gray, width: 1)
                            .shadow(color: Color.gray.opacity(0.5), radius: 1, x: 0, y: 0)
                            .frame(width: 12, height: 4)
                    }
                }
                .offset(x: -47, y: 0)
            }
        }
    }
}

// Previews demonstrating different color combinations
struct NotebookIcon_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 20) {
            NotebookIcon() // Default
            NotebookIcon(primaryColor: .red, secondaryColor: .white, bindingColor: .gray, linesColor: .blue)
            NotebookIcon(primaryColor: .green, secondaryColor: .yellow.opacity(0.3), bindingColor: .white, linesColor: .black)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
