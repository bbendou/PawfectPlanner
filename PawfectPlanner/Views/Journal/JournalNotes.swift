import SwiftUI

struct JournalNotes: View {
    @Binding var noteText: String // ✅ Binding for user input

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("NOTES")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.tailwindYellow700)
                .padding(.top, 10)

            // ✅ Editable Text Area with dynamic height
            TextEditor(text: $noteText)
                .font(.title2)
                .foregroundColor(.black)
                .frame(maxWidth: 327, minHeight: 150, maxHeight: 250) // ✅ Matches image card width
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .frame(width: 290) // ✅ Matches image card width
        .padding(.horizontal, 28)
        .padding(.top, 10)
        .padding(.bottom, 28)
        .background(Color.tailwindRed100)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
}

struct JournalNotes_Previews: PreviewProvider {
    static var previews: some View {
        JournalNotes(noteText: .constant("Hello my people"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
