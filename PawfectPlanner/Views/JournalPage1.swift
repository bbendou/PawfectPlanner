import SwiftUI

struct JournalPage1: View {
    @State private var noteText: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var selectedDate: Date = Date() // Stores the selected date
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
                        journalController.saveEntry(noteText, date: selectedDate) // ✅ Save date too
                        presentationMode.wrappedValue.dismiss()
                    }
                )

                // ✅ Date & Time Picker Section
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

                // ✅ Image Upload Section
                AddImageView(selectedImage: $selectedImage)
                    .padding(.top, 14)

                // ✅ Add More Spacing Below Image Section to Push Notes Down
                Spacer(minLength: 50) // ⬅️ Add spacing before the Notes section

                // ✅ Notes Section
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
