import SwiftUI
import PhotosUI

struct AddImageView: View {
    @Binding var selectedImage: UIImage?
    @State private var isPickerPresented = false // Controls image picker visibility

    var body: some View {
        JournalCard(height: 270) { // Keeps the card design
            ZStack {
                // Display selected image or default placeholder
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                } else {
                    Image("default_cat") // Default placeholder
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                }
            }
        }
        .frame(width: 327) // Matches JournalNotes width
        .padding(.top, 14)
        .overlay(
            VStack {
                Spacer()
                AddImageButton(action: {
                    isPickerPresented = true // ✅ Opens the image picker when tapped
                })
                .padding(.bottom, 15) // Centers button at bottom of card
            }
        )
        .fullScreenCover(isPresented: $isPickerPresented) { // ✅ Prevents navigation issues
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

struct AddImageView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageView(selectedImage: .constant(nil))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
