//
//  NameListView.swift
//  ideonym
//
//  Created by GK Naidu on 02/02/25.
//
import SwiftUI

struct NameListView: View {
    @ObservedObject var viewModel: BusinessNameViewModel

    var body: some View {
        ZStack {
            // ✅ Fullscreen Animated Background
            AnimatedMeshGradient()
                .edgesIgnoringSafeArea(.all)

            VStack {
                if viewModel.isLoading {
                    GeneratingProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            Spacer(minLength: 80) // ✅ Pushes cards lower to avoid X button overlap
                            ForEach(viewModel.generatedNames) { name in
                                NameCardView(name: name) // ✅ Uses improved frosted glass
                            }
                            Spacer(minLength: 40) // ✅ Adds spacing before the bottom button
                        }
                        .padding(.horizontal, 20)
                    }

                    // ✅ Generate Again Button (Fixed at Bottom)
                    Button(action: {
                        viewModel.isLoading = true
                        viewModel.generateBusinessNames {
                            DispatchQueue.main.async {
                                viewModel.isLoading = false
                            }
                        }
                    }) {
                        Text("Generate Again")
                            .frame(maxWidth: 600)
                            .padding()
                            .background(Color.white.opacity(0.15)) // ✅ Matches glass effect
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    .safeAreaInset(edge: .bottom) { // ✅ Ensures button is not too low
                        Color.clear.frame(height: 30)
                    }
                }
            }
            .padding(.horizontal, 16) // ✅ Keeps content structured
        }
    }
}

#Preview {
    NameListView(viewModel: BusinessNameViewModel())
}
