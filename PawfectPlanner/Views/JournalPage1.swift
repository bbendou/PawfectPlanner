import SwiftUI

struct JournalPage1: View {
    @State private var noteText: String = "My cat just turned 2!!\nHe is so silly and squishy\nI got him his favourite treat of tuna >-<"
    @State private var selectedImage: UIImage? = nil // ✅ Move selected image here
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var journalController: JournalController

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Top Navigation Bar
                TopNavBar(
                    onPrev: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    onNext: {
                        journalController.saveEntry(noteText)
                        presentationMode.wrappedValue.dismiss()
                    }
                )

                // Date and Time section
                HStack(spacing: 6) {
                    HStack(spacing: 6) {
                        Text("Jan 8th,")
                            .font(.body)
                            .fontWeight(.medium)

                        Text("2022")
                            .font(.body)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)

                    Text("7:39 PM")
                        .font(.body)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                }
                .foregroundColor(Color.tailwindBlue500)
                .padding(.top, 8)

                // ✅ Image Upload Section (Pass `selectedImage` to AddImageView)
                AddImageView(selectedImage: $selectedImage)
                    .padding(.top, 14)

                // Notes Section
                JournalNotes(noteText: $noteText)

                Spacer()
            }

            // Bottom Navigation Bar
            VStack {
                Spacer()
                BottomNavBar()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarBackButtonHidden(true) // Hides "< Back"
    }
}

struct JournalPage1_Previews: PreviewProvider {
    static var previews: some View {
        JournalPage1(journalController: JournalController())
    }
}
