//
//  SelectToneView.swift
//  ideonym
//
//  Created by GK Naidu on 04/02/25.
//
import SwiftUI

struct SelectToneView: View {
    @ObservedObject var viewModel: BusinessNameViewModel

    let tones = ["Professional", "Friendly", "Innovative", "Luxury", "Other"]
    @State private var showProgressView = false // Tracks if the progress animation should show
    @State private var navigateToNameListView = false // State for programmatic navigation

    var body: some View {
        VStack {
            if showProgressView {
                ProgressView("Generating Names...")
                    .foregroundColor(.white)
                    .scaleEffect(1.5)
                    .padding()
            } else {
                Text("Select a Tone")
                    .font(.title2)
                    .foregroundColor(.white)

                VStack {
                    ForEach(tones, id: \.self) { tone in
                        Button(action: { viewModel.selectedTone = tone }) {
                            HStack {
                                Text(tone)
                                    .foregroundColor(.white)
                                Spacer()
                                if viewModel.selectedTone == tone {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()

                Spacer()

                Button(action: {
                    generateNames() // Trigger name generation and navigate on success
                }) {
                    Text("Generate")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.selectedTone.isEmpty ? Color.gray : Color.red)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .padding()
                }
                .disabled(viewModel.selectedTone.isEmpty)

          
                .fullScreenCover(isPresented: $navigateToNameListView) {
                    NameListView(viewModel: viewModel)
                }
                
            }
        }
        .background(LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }

    private func generateNames() {
        showProgressView = true // Show the progress animation
        viewModel.generateBusinessNames { // Fetch names from the API
            DispatchQueue.main.async {
                showProgressView = false
                navigateToNameListView = true // Navigate to the NameListView after success
            }
        }
    }
}

#Preview {
    SelectToneView(viewModel: BusinessNameViewModel())
}
