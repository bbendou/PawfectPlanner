//
//  MyJournalView.swift
//  PawfectPlanner
//
//  Created by Bushra Bendou on 02/04/2025.
//

import SwiftUI
import WebKit

struct MyJournalView: View {
    @ObservedObject var journalController: JournalController
    @State private var currentEntryIndex = 0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Top Navigation Bar with Prev/Next for entries
                TopNavBar(
                    onPrev: {
                        // If we're at the first entry, go back to main page
                        if currentEntryIndex == 0 {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            currentEntryIndex -= 1
                        }
                    },
                    onNext: {
                        if currentEntryIndex < journalController.entries.count - 1 {
                            currentEntryIndex += 1
                        }
                    }
                )

                if !journalController.entries.isEmpty {
                    let entry = journalController.entries[currentEntryIndex]

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
                            // Image Display using JournalCard
                            if let imageString = entry.imageURL, !imageString.isEmpty {
                                JournalCard(height: 270) {
                                    if imageString.hasPrefix("data:image/jpeg;base64,"),
                                       let dataString = imageString.components(separatedBy: ",").last,
                                       let imageData = Data(base64Encoded: dataString),
                                       let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 250, height: 250)
                                            .clipShape(RoundedRectangle(cornerRadius: 24))
                                    } else {
                                        Image("default_cat")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 250, height: 250)
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
                                        // For YouTube links
                                        YouTubeView(videoURL: videoURL)
                                            .frame(height: 250)
                                            .cornerRadius(12)
                                            .padding(.horizontal, 16)
                                    } else if videoURL.contains("vimeo.com") {
                                        // For Vimeo links
                                        WebView(urlString: videoURL)
                                            .frame(height: 250)
                                            .cornerRadius(12)
                                            .padding(.horizontal, 16)
                                    } else {
                                        Text("Video URL: \(videoURL)")
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

                                Text(entry.content)
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: 327, minHeight: 150, maxHeight: 250)
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

                    Spacer()
                } else {
                    Text("No journal entries yet")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            journalController.fetchEntries()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// WebView to display Vimeo videos
struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

// Specialized YouTube video player (more optimized)
struct YouTubeView: UIViewRepresentable {
    let videoURL: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Extract video ID from YouTube URL
        var videoID = ""
        if let url = URL(string: videoURL) {
            if videoURL.contains("youtube.com") {
                // Format: https://www.youtube.com/watch?v=VIDEO_ID
                if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
                    for item in queryItems where item.name == "v" {
                        videoID = item.value ?? ""
                        break
                    }
                }
            } else if videoURL.contains("youtu.be") {
                // Format: https://youtu.be/VIDEO_ID
                videoID = url.lastPathComponent
            }
        }

        if !videoID.isEmpty {
            // Use YouTube embedded player format
            let embedURLString = "https://www.youtube.com/embed/\(videoID)"
            if let embedURL = URL(string: embedURLString) {
                let request = URLRequest(url: embedURL)
                uiView.load(request)
            }
        } else {
            // Fallback to direct URL if we couldn't parse the video ID
            if let url = URL(string: videoURL) {
                let request = URLRequest(url: url)
                uiView.load(request)
            }
        }
    }
}

struct MyJournalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MyJournalView(journalController: JournalController())
        }
    }
}
