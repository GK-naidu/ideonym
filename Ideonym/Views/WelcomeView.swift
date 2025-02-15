//
//  HomeView.swift
//  ideonym
//
//  Created by GK Naidu on 02/02/25.
//

import SwiftUI

struct WelcomeScreensView: View {
    let onFinish: () -> Void
    @State private var currentIndex: Int = 0

    // ✅ Welcome screen data
    private let welcomeScreens = [
        WelcomeScreenModel(title: "Welcome to Ideonym!", description: "Generate creative business names based on your idea, category, and tone."),
        WelcomeScreenModel(title: "Tailored to Your Needs", description: "Select a category and brand tone to get names that match your vision."),
        WelcomeScreenModel(title: "Get Started", description: "Let’s create something amazing together!")
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                Text(welcomeScreens[currentIndex].title)
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text(welcomeScreens[currentIndex].description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 10)

                Spacer()

                HStack {
                    if currentIndex < welcomeScreens.count - 1 {
                        Button(action: { nextScreen() }) {
                            Image(systemName: "chevron.right.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.white.opacity(0.8)) // ✅ Softer White
                        }
                        .padding()
                    } else {
                        Button(action: { onFinish() }) {
                            Text("Get Started")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.2)) // ✅ White with Reduced Opacity
                                .cornerRadius(12)
                        }
                        .padding()
                    }
                }
            }
        }
        .animation(.easeInOut, value: currentIndex)
    }

    private func nextScreen() {
        if currentIndex < welcomeScreens.count - 1 {
            currentIndex += 1
        }
    }
}

// ✅ Data Model for Welcome Screens
struct WelcomeScreenModel {
    let title: String
    let description: String
}


