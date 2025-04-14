import SwiftUI
import WebKit

// MARK: - Mock Data Structures
struct MockJournalEntry: Identifiable { // Renamed slightly for clarity if needed elsewhere
    let id = UUID()
    let timestamp: Date
    let imageURL: String?
    let videoURL: String?
    let fullContent: String
}

struct MockPublicJournal: Identifiable {
    let id = UUID()
    let username: String
    let petName: String
    // Array of entries for this journal
    let entries: [MockJournalEntry]
    // Add properties needed for the preview card, like primary color
    let primaryColor: Color
    let secondaryColor: Color
    let bindingColor: Color
    let linesColor: Color
}

// MARK: - Mock Data Generation
func generateMockJournals() -> [MockPublicJournal] {
    let colors = NotebookColors.pairs // Use the defined colors

    let journal1Entries = [
        MockJournalEntry(timestamp: Date().addingTimeInterval(-86400 * 5), imageURL: "https://i.imgur.com/U21L5O5.jpeg", videoURL: nil, fullContent: "Entry 1: Had a great walk in the park today! Buddy loved chasing squirrels."),
        MockJournalEntry(timestamp: Date().addingTimeInterval(-86400 * 2), imageURL: "https://i.imgur.com/GqlK0HQ.jpeg", videoURL: nil, fullContent: "Entry 2: Buddy learned to sit! So proud.")
    ]
    let journal1ColorIndex = 0
    let journal1Colors = colors[journal1ColorIndex]

    let journal2Entries = [
        MockJournalEntry(timestamp: Date().addingTimeInterval(-86400 * 1), imageURL: nil, videoURL: "https://youtu.be/tAcjl9S9exw?si=wB0CYoG2zIAZifE1", fullContent: "Luna learned a new trick! She can finally roll over. Check out the video!")
        // Only one entry for Luna
    ]
    let journal2ColorIndex = 1
    let journal2Colors = colors[journal2ColorIndex]

    let journal3Entries = [
         MockJournalEntry(timestamp: Date().addingTimeInterval(-86400 * 10), imageURL: "https://i.imgur.com/qTRdarZ.jpeg", videoURL: nil, fullContent: "Entry 1: Max is sleepy."),
         MockJournalEntry(timestamp: Date(), imageURL: "https://i.imgur.com/qTRdarZ.jpeg", videoURL: nil, fullContent: "Entry 2: Lazy Sunday vibes... Max just slept all day.")
    ]
    let journal3ColorIndex = 2
    let journal3Colors = colors[journal3ColorIndex]

    let journal4Entries = [
         MockJournalEntry(timestamp: Date().addingTimeInterval(-86400 * 3), imageURL: "https://i.imgur.com/PodQVMh.jpeg", videoURL: nil, fullContent: "Beach day fun! Rocky enjoyed digging in the sand.")
    ]
    let journal4ColorIndex = 3
    let journal4Colors = colors[journal4ColorIndex]

    let journal5Entries = [
         MockJournalEntry(timestamp: Date().addingTimeInterval(-86400 * 4), imageURL: nil, videoURL: "https://youtu.be/RFMuw3xpmFE?si=-vzxVuSDFjrNggWS", fullContent: "Coco had the funniest zoomies around the living room this morning. So much energy!")
    ]
    let journal5ColorIndex = 4
    let journal5Colors = colors[journal5ColorIndex]


    return [
        MockPublicJournal(username: "Alice", petName: "Buddy", entries: journal1Entries, primaryColor: journal1Colors.primary, secondaryColor: journal1Colors.secondary, bindingColor: journal1Colors.binding, linesColor: journal1Colors.lines),
        MockPublicJournal(username: "Bob", petName: "Luna", entries: journal2Entries, primaryColor: journal2Colors.primary, secondaryColor: journal2Colors.secondary, bindingColor: journal2Colors.binding, linesColor: journal2Colors.lines),
        MockPublicJournal(username: "Charlie", petName: "Max", entries: journal3Entries, primaryColor: journal3Colors.primary, secondaryColor: journal3Colors.secondary, bindingColor: journal3Colors.binding, linesColor: journal3Colors.lines),
        MockPublicJournal(username: "Diana", petName: "Rocky", entries: journal4Entries, primaryColor: journal4Colors.primary, secondaryColor: journal4Colors.secondary, bindingColor: journal4Colors.binding, linesColor: journal4Colors.lines),
        MockPublicJournal(username: "Eve", petName: "Coco", entries: journal5Entries, primaryColor: journal5Colors.primary, secondaryColor: journal5Colors.secondary, bindingColor: journal5Colors.binding, linesColor: journal5Colors.lines)
    ]
}

// MARK: - Color Pairs for Notebooks
struct NotebookColors {
    static let pairs: [(primary: Color, secondary: Color, binding: Color, lines: Color)] = [
        (Color.blue, Color.gray.opacity(0.2), Color.white, Color.black),
        (Color.red, Color.yellow.opacity(0.3), Color.white, Color.black),
        (Color.green, Color.orange.opacity(0.2), Color.white, Color.black),
        (Color.purple, Color.gray.opacity(0.1), Color.white, Color.black),
        (Color.orange, Color.blue.opacity(0.1), Color.white, Color.black)
    ]
}

// MARK: - Browse Journals View
struct BrowseJournalsView: View {

    // Use the generated mock journals
    let mockPublicJournals = generateMockJournals()

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                // Iterate over journals
                ForEach(mockPublicJournals) { journal in
                    NavigationLink(destination: MultiEntryPublicJournalView(journal: journal)) { // Navigate to new view
                         // Pass the whole journal to the preview card
                         JournalPreviewCard(journal: journal)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationTitle("Browse Journals")
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

// MARK: - Journal Preview Card (Updated to accept MockPublicJournal)
struct JournalPreviewCard: View {
    let journal: MockPublicJournal // Accepts the whole journal

    var body: some View {
        VStack(spacing: 8) {
            // Use colors from the journal object
            NotebookIcon(primaryColor: journal.primaryColor,
                         secondaryColor: journal.secondaryColor,
                         bindingColor: journal.bindingColor,
                         linesColor: journal.linesColor)
                .padding(.bottom, 8)

            Text(journal.petName)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)

            Text("by \(journal.username)")
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(height: 200)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Multi-Entry Public Journal Detail View (Implementation)
struct MultiEntryPublicJournalView: View {
    let journal: MockPublicJournal
    @State private var currentEntryIndex = 0
    @Environment(\.presentationMode) var presentationMode

    // Check if there's a next entry
    private var hasNextEntry: Bool {
        currentEntryIndex < journal.entries.count - 1
    }

    // Get the current entry to display
    private var currentEntry: MockJournalEntry {
        // Safety check, though index should be valid
        guard journal.entries.indices.contains(currentEntryIndex) else {
            // Return a default/empty entry or handle error appropriately
            // For mock data, we assume the index is always valid based on navigation logic
            return journal.entries[0]
        }
        return journal.entries[currentEntryIndex]
    }

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Top Navigation Bar (Similar to MyJournalView's TopNavBar logic)
                HStack {
                    // Back/Prev Button
                    Button {
                        if currentEntryIndex == 0 {
                            presentationMode.wrappedValue.dismiss() // Go back to Browse
                        } else {
                            currentEntryIndex -= 1 // Go to previous entry
                        }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text(currentEntryIndex == 0 ? "Browse" : "Prev") // Dynamic label
                        }
                    }
                    .padding()

                    Spacer()

                    // Title (Pet Name & Index)
                    Text("\(journal.petName) (\(currentEntryIndex + 1)/\(journal.entries.count))")
                        .font(.headline)
                        .lineLimit(1)
                        .padding(.horizontal)

                    Spacer()

                    // Next Button (Enabled only if there's a next entry)
                    Button {
                        if hasNextEntry {
                            currentEntryIndex += 1
                        }
                    } label: {
                        Text("Next")
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .disabled(!hasNextEntry) // Disable if no next entry
                    .opacity(hasNextEntry ? 1 : 0.5) // Visual cue for disabled state

                }
                .background(Color.tailwindBlue900.opacity(0.8))
                .foregroundColor(.white)

                // Entry Content Area (Copied/Adapted from previous PublicJournalEntryView layout)
                EntryContentView(entry: currentEntry) // Use a dedicated content view

            }
        }
        .navigationBarHidden(true) // Hide default nav bar
    }
}

// MARK: - Entry Content View (Extracted reusable part)
struct EntryContentView: View {
    let entry: MockJournalEntry

    var body: some View {
        VStack(spacing: 0) { // Outer VStack for date + ScrollView
             // Date & Time display
            HStack(spacing: 6) {
                Text(formattedDate(entry.timestamp))
                    .font(.system(size: 16))
                    .foregroundColor(Color.tailwindBlue500)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
            }
            .padding(.top, 8)

            ScrollView {
                VStack(spacing: 16) {
                    // Updated Image Display
                    if let imageString = entry.imageURL, !imageString.isEmpty {
                        JournalCard(height: 270) {
                            if imageString.hasPrefix("data:image/jpeg;base64,"), // Handle Base64
                               let dataString = imageString.components(separatedBy: ",").last,
                               let imageData = Data(base64Encoded: dataString),
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250, height: 250)
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                            } else if let imageURL = URL(string: imageString) { // Handle URL
                                AsyncImage(url: imageURL) {
                                    phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 250, height: 250)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 250, height: 250)
                                            .clipShape(RoundedRectangle(cornerRadius: 24))
                                    case .failure:
                                        Image(systemName: "photo.fill") // Placeholder on failure
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 250, height: 250)
                                            .foregroundColor(.gray)
                                            .clipShape(RoundedRectangle(cornerRadius: 24))
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else { // Fallback placeholder
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250, height: 250)
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                            }
                        }
                        .frame(width: 327)
                        .padding(.top, 14)
                    }

                    // Video Display
                    if let videoURL = entry.videoURL, !videoURL.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("VIDEO")
                                .font(.headline)
                                .foregroundColor(Color.tailwindYellow700)
                                .padding(.leading, 16)

                            if videoURL.contains("youtube.com") || videoURL.contains("youtu.be") {
                                YouTubeView(videoURL: videoURL)
                                    .frame(height: 250)
                                    .cornerRadius(12)
                                    .padding(.horizontal, 16)
                            } else if videoURL.contains("vimeo.com") {
                                WebView(urlString: videoURL)
                                    .frame(height: 250)
                                    .cornerRadius(12)
                                    .padding(.horizontal, 16)
                            } else {
                                Text("Video URL: \(videoURL)") // Fallback for other URLs
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 16)
                            }
                        }
                        .padding(.vertical, 12)
                        .background(Color.tailwindRed100)
                        .cornerRadius(16)
                        .padding(.top, 14)
                    }

                    // Notes Display
                    VStack(alignment: .leading, spacing: 0) {
                        Text("NOTES")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.tailwindYellow700)
                            .padding(.top, 10)

                        Text(entry.fullContent) // Use fullContent from MockEntry
                            .font(.title2)
                            .foregroundColor(.black)
                            .frame(maxWidth: 327, alignment: .leading) // Allow dynamic height
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .frame(width: 290)
                    .padding(.horizontal, 28)
                    .padding(.top, 10)
                    .padding(.bottom, 28)
                    .background(Color.tailwindRed100)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                }
                .padding(.bottom, 20)
            }
             Spacer() // Push content up
        }
    }

    // Helper function to format date (needs to be accessible)
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Previews (Need Updates)
struct BrowseJournalsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
             BrowseJournalsView()
        }
    }
}

struct JournalPreviewCard_Previews: PreviewProvider {
    static var previews: some View {
        // Need to create a sample MockPublicJournal for preview
        let sampleJournal = generateMockJournals()[0]
        JournalPreviewCard(journal: sampleJournal)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

struct MultiEntryPublicJournalView_Previews: PreviewProvider {
     static var previews: some View {
         let sampleJournal = generateMockJournals()[0] // Journal with multiple entries
          NavigationView {
              MultiEntryPublicJournalView(journal: sampleJournal)
          }
     }
 }

// Remove or comment out the old PublicJournalEntryView if no longer needed
// struct PublicJournalEntryView: View { ... }
// struct PublicJournalEntryView_Previews: PreviewProvider { ... }

// Helper views like WebView and YouTubeView should ideally be moved to a separate Utilities file
// or ensured they are accessible (e.g., defined in MyJournalView.swift)