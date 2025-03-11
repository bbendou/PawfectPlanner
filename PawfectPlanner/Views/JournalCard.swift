import SwiftUI

struct JournalCard<Content: View>: View {
    let height: CGFloat
    let content: Content

    init(height: CGFloat, @ViewBuilder content: () -> Content) {
        self.height = height
        self.content = content()
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.tailwindRed100)
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
}

struct JournalCard_Previews: PreviewProvider {
    static var previews: some View {
        JournalCard(height: 350) {
            Text("Sample Card")
        }
        .frame(width: 350, height: 350)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}