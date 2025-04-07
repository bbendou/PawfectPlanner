import SwiftUI

struct JournalPage1: View {
    @State private var noteText: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var selectedDate: Date = Date() // Stores the selected date
    @State private var videoURL: String = "" // New state for video URL
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
                        // Save the journal entry with text, image, date, and video URL.
                        journalController.saveEntry(noteText, image: selectedImage, date: selectedDate, videoURL: videoURL.isEmpty ? nil : videoURL)
                        presentationMode.wrappedValue.dismiss()
                    }
                )

                // Date & Time Picker Section
                HStack(spacing: 6) {
                    // Date Picker
                    DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)

                    // Time Picker
                    DatePicker("", selection: $selectedDate, displayedComponents: [.hourAndMinute])
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                }
                .foregroundColor(Color.tailwindBlue500)
                .padding(.top, 8)

                // Image Upload Section
                AddImageView(selectedImage: $selectedImage)
                    .padding(.top, 14)

                // Video URL Input
                VideoLinkInput(videoURL: $videoURL)
                    .padding(.top, 14)

                Spacer(minLength: 20)

                // Notes Section
                JournalNotes(noteText: $noteText)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct JournalPage1_Previews: PreviewProvider {
    static var previews: some View {
        JournalPage1(journalController: JournalController())
    }
}
