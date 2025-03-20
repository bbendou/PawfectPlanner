import SwiftUI

struct WelcomeView: View {
    @State private var navigateToCreateAccount = false
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.tailwindBrown1
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            // Logo
                            Image("Logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 400, height: 300)
                                .padding(.top, 70)
                                .accessibilityLabel("Pet care logo")
                            
                            // **Centered Rounded Text**
                            Text("The ultimate assistant to pet parents")
                                .font(.system(size: 35))
                                .fontWeight(.bold)
                                .lineSpacing(-3)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color.brown1)
                                .cornerRadius(60)
                                .padding(.horizontal, 20)
                                .padding(.top, 50)
                            
                            // Get Started Button
                            Button(action: {
                                navigateToCreateAccount = true
                            }) {
                                Text("Get Started!")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color.white)
                                    .lineSpacing(2)
                                    .frame(maxWidth: 230)
                                    .padding(.vertical, 10)
                                    .background(Color.blue1)
                                    .cornerRadius(20)
                            }
                            .scaleOnPress()
                            .padding(.top, 30)
                            .padding(.bottom, 10)
                            
                            // Small Login Text
                            Button(action: {
                                navigateToLogin = true
                            }) {
                                Text("Have an account? Log in here.")
                                    .font(.system(size: 15))
                                    .foregroundColor(.darkBrown1)
                                    .underline()
                            }
                            .padding(.bottom, 50)
                            
                            // Navigation Destinations
                            .navigationDestination(isPresented: $navigateToCreateAccount) {
                                CreateAccountView()
                            }
                            .navigationDestination(isPresented: $navigateToLogin) {
                                LoginView()
                            }
                            
                            Spacer()
                        }
                        .frame(minHeight: geometry.size.height)
                    }
                    .background(
                        ZStack {
                            Color.tailwindBrown1
                            Image("PawTrail")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 1000)
                                .accessibilityLabel("Paw prints trail")
                        }
                        .edgesIgnoringSafeArea(.all)
                    )
                }
            }
        }
    }
}

// **Preview**
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WelcomeView()
        }
    }
}

