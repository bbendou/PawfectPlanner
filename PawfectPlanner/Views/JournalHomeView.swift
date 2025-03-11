import SwiftUI

struct JournalHomeView: View {
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Header
                Text("Journal")
                    .font(.system(size: 32))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 94)
                    .background(Color.tailwindBlue900)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                // Main content
                ScrollView {
                    VStack(spacing: 40) {
                        // View Journal Card
                        JournalCard(height: 350) {
                            VStack(spacing: 40) {
                                NotebookIcon()
                                    .frame(width: 99, height: 133)

                                Text("View My Journal")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.tailwindYellow700)
                            }
                        }
                        .frame(width: 350, height: 350)
                        .responsiveFrame()

                        // Add New Entry Button
                        NewEntryButton()
                            .responsiveFrame()

                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }

                Spacer(minLength: 0)
            }

            // Bottom Navigation Bar
            VStack {
                Spacer()
                BottomNavBar()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

// Extension to make frames responsive
extension View {
    func responsiveFrame() -> some View {
        self.modifier(ResponsiveFrameModifier())
    }
}

struct ResponsiveFrameModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    func body(content: Content) -> some View {
        if horizontalSizeClass == .compact {
            return AnyView(
                content
                    .frame(maxWidth: 280)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
            )
        } else {
            return AnyView(content)
        }
    }
}

struct JournalHomeView_Previews: PreviewProvider {
    static var previews: some View {
        JournalHomeView()
    }
}
