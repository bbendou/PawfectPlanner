import SwiftUI

struct AddImageView: View {
    @State private var selectedImage: Image? = Image("default_cat") // Default image

    var body: some View {
        JournalCard(height: 270) { // Uses JournalCard to wrap image
            VStack {
                // Display selected image or default cat
                selectedImage?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                Spacer(minLength: 20) // Space between image and button
            }
            .padding(.bottom, 40) // Adjusts padding so button doesn't touch the bottom
        }
        .frame(width: 327) // ✅ Ensures the width matches `JournalNotes`
        .padding(.top, 14)
        .overlay(
            VStack {
                Spacer()
                AddImageButton(action: {
                    print("Add Image Button Pressed") // Implement image picker later
                })
                .padding(.bottom, 15) // Centers button at the bottom of the card
            }
        )
    }
}

struct AddImageView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
