import SwiftUI

struct VideoLinkInput: View {
    @Binding var videoURL: String
    @State private var isExpanded = false
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(spacing: 12) {
            Button(action: {
                isExpanded.toggle()
            }) {
                HStack {
                    Image(systemName: "video.fill")
                        .foregroundColor(Color.tailwindBlue900)

                    Text(videoURL.isEmpty ? "Add YouTube/Vimeo Video" : "Video Added")
                        .font(.headline)
                        .foregroundColor(Color.tailwindBlue900)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color.tailwindBlue900)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Paste YouTube or Vimeo URL")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    TextField("https://www.youtube.com/watch?v=...", text: $videoURL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                        .focused($isInputFocused)

                    HStack {
                        Spacer()

                        Button("Done") {
                            isExpanded = false
                            isInputFocused = false
                        }
                        .foregroundColor(Color.tailwindBlue900)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }

                    Text("1. Upload your video to YouTube/Vimeo")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text("2. Set to 'Unlisted' for privacy (optional)")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text("3. Copy & paste the video URL here")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .transition(.opacity)
                .animation(.easeInOut, value: isExpanded)
            }
        }
        .padding(.horizontal)
    }
}

struct VideoLinkInput_Previews: PreviewProvider {
    static var previews: some View {
        VideoLinkInput(videoURL: .constant(""))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}