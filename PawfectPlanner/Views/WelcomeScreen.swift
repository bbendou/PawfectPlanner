//
//  WelcomeScreen.swift
//  PawfectPlanner
//
//  Created by Sarim Faraz on 14/03/2025.
//

import SwiftUI

struct WelcomeView: View {
    @State private var isButtonPressed = false
    @State private var navigateToLogin = false

    var body: some View {
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
                        .font(.custom("Jersey10", size: geometry.size.width < 640 ? 40 : (geometry.size.width < 991 ? 46 : 52)))
                        .lineSpacing(geometry.size.width < 640 ? -6 : -14)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.top, geometry.size.width < 640 ? 40 : (geometry.size.width < 991 ? 60 : 80))

                    // Get Started Button
                    Button(action: {
                        navigateToLogin = true
                    }) {
                        Text("Get Started")
                            .font(.custom("Jersey10", size: geometry.size.width < 640 ? 34 : (geometry.size.width < 991 ? 400 : 42)))
                            .foregroundColor(.primaryGreen)
                            .frame(maxWidth: 280)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 0)
                            .background(Color.buttonBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .cornerRadius(30)
                    }
                    .scaleOnPress()
                    .padding(.top, geometry.size.width < 640 ? 100 : (geometry.size.width < 991 ? 220 : 260))
                    .padding(.bottom, geometry.size.width < 640 ? 30 : 40)
//                    .background(
//                        NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
//                            EmptyView()
//                        }
//                        .hidden()
//                    )

                    Spacer()
                }
                .frame(minHeight: geometry.size.height)
            }
            .background(
                ZStack {
                    Color.white
                    // Paw Trail Image
                    AsyncImage(url: URL(string: "https://cdn.builder.io/api/v1/image/assets/TEMP/9665a143028d2f5cdd7a47fbf6700be4715fbdb1&format=webp")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: 597)
                    .position(x: geometry.size.width / 2, y: geometry.size.height)
                    .accessibilityLabel("Paw prints trail")
                }
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
