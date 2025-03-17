//
//  WelcomeScreen.swift
//  PawfectPlanner
//
//  Created by Sarim Faraz on 14/03/2025.
//
import SwiftUI

struct WelcomeView: View {
    @State private var navigateToCreateAccount = false
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 300) // Adjust size as needed
                            .padding(.top, 70) // Adjust top spacing
                            .accessibilityLabel("Pet care logo")
                        
                        // Heading Text
                        Text("The ultimate assistant to pet parents!")
                            .font(.custom("Jersey10", size: 40))
                            .lineSpacing(geometry.size.width < 640 ? -6 : -14)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.tailwindBrown3)
                            .padding(.horizontal, 20)
                            .padding(.top, geometry.size.width < 640 ? 40 : (geometry.size.width < 991 ? 60 : 80))
                        
                        // Get Started Button
                        Button(action: {
                            navigateToCreateAccount = true
                        }) {
                            Text("Get Started!")
                                .font(.custom("Jersey10", size: 30))
                                .foregroundColor(Color.tailwindBrown3)
                                .frame(maxWidth: 250)
                                .padding(.vertical, 10)
                                .background(Color.buttonBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 0)
                                )
                                .cornerRadius(20)
                        }
                        .scaleOnPress()
                        .padding(.top, geometry.size.width < 640 ? 100 : (geometry.size.width < 991 ? 220 : 260))
                        .padding(.bottom, 10)

                        // Small Login Text
                        Button(action: {
                            navigateToLogin = true
                        }) {
                            Text("Have an account? Log in here.")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .underline()
                        }
                        .padding(.bottom, 40)

                        // Navigation Destinations
                        .navigationDestination(isPresented: $navigateToCreateAccount) {
                            CreateAccountView() // Navigate to Create Account
                        }
                        .navigationDestination(isPresented: $navigateToLogin) {
                            LoginView() // Navigate to Login Screen
                        }

                        Spacer()
                    }
                    .frame(minHeight: geometry.size.height)
                }
                .background(
                    ZStack {
                        Color.white
                        Image("PawTrail")  // Ensure this image is in your Assets folder
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 900)
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.93)
                            .accessibilityLabel("Paw prints trail")
                    }
                    .edgesIgnoringSafeArea(.all)
                )
            }
        }
    }
}

// **Preview for Xcode Canvas**
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WelcomeView()
        }
    }
}


