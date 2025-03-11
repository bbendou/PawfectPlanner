import SwiftUI

struct NotebookIcon: View {
    var isInverted: Bool = false // Flag to toggle colors

    var body: some View {
        ZStack {
            // Main notebook body
            Rectangle()
                .fill(isInverted ? Color.white : Color.tailwindBlue900) // Toggle colors
                .border(Color.black, width: 1)
                .frame(width: 99, height: 133)

            // Notebook content
            ZStack {
                // Lines container
                Rectangle()
                    .fill(isInverted ? Color.tailwindBlue900 : Color.tailwindZinc100) // Toggle colors
                    .border(Color.black, width: 1)
                    .frame(width: 51, height: 27)
                    .offset(x: 0, y: -43.5)

                // Lines inside container
                VStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { _ in
                        Rectangle()
                            .fill(isInverted ? Color.white : Color.black) // Toggle colors
                            .frame(width: 30, height: 1)
                    }
                }
                .offset(x: 0, y: -43.5)

                // Binding holes
                VStack(spacing: 10) {
                    ForEach(0..<8, id: \.self) { _ in
                        Rectangle()
                            .fill(isInverted ? Color.tailwindBlue900 : Color.white) // Toggle colors
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

// Previews for both versions
struct NotebookIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            NotebookIcon() // Default (Blue Notebook)
            NotebookIcon(isInverted: true) // Inverted (White Notebook)
        }
        .frame(width: 99, height: 133)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
