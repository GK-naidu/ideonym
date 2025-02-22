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
                        // ✅ Heading for Generated Names
                        Text("Generated Names")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 20)

                        // ✅ Generated Name Cards
                        ForEach(viewModel.generatedNames) { name in
                            NameCardView(name: name)
                        }

                        // ✅ Generate Again Button (Inside ScrollView)
                        Button(action: {
                            viewModel.isLoading = true
                            viewModel.generateBusinessNames {
                                DispatchQueue.main.async {
                                    viewModel.isLoading = false
                                }
                            }
                        }) {
                            Text("Generate More Names")
                                .frame(maxWidth: 600)
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

#Preview {
    NameListView(viewModel: BusinessNameViewModel())
}
