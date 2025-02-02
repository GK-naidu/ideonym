//
//  IdeaInputView.swift
//  ideonym
//
//  Created by GK Naidu on 02/02/25.
//

import SwiftUI

struct IdeaInputView: View {
    @State private var businessIdea: String = ""
    @State private var isLoading: Bool = false
    @State private var navigateToResults: Bool = false
    @StateObject private var viewModel = NameViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                // MARK: - Title
                Text("Enter Your Idea")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                // MARK: - TextField Input
                IdeaTextField(text: $businessIdea)
                    .padding(.horizontal)
                
                // MARK: - Generate Button or ProgressView
                if isLoading {
                    LoadingIndicator()
                } else {
                    GenerateButton(action: {
                        Task {
                            await generateNames()
                        }
                    })
                }
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
            // MARK: - Hidden Navigation Link (iOS 16+ Approach)
                .navigationDestination(isPresented: $navigateToResults) {
                    NameListView(viewModel: viewModel)
                }

        }
    }
    
    // MARK: - Function to Generate Names
    private func generateNames() async {
        guard !businessIdea.isEmpty else { return }
        isLoading = true
        await viewModel.fetchBusinessNames()
        isLoading = false
        navigateToResults = true
    }
    private struct GenerateButton: View {
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text("Generate Names")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .frame(maxHeight: .infinity, alignment: .bottom) // Align button to bottom
            .padding(.bottom, 20) // Add padding for spacing
        }
    }
    
    
    private struct IdeaTextField: View {
        @Binding var text: String
        
        var body: some View {
            TextField("Describe your business idea...", text: $text,axis : .vertical)
                .lineLimit(5...7)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 10)
                .disableAutocorrection(true)
        }
    }
    private struct LoadingIndicator: View {
        var body: some View {
            ProgressView("Generating...")
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

#Preview {
    IdeaInputView()
}
