//
//  IdeaInputView.swift
//  ideonym
//
//  Created by GK Naidu on 02/02/25.
//

import SwiftUI

struct IdeaInputView: View {
    @ObservedObject var viewModel: BusinessNameViewModel
    
    var body: some View {
        VStack {
            Text("Enter Your Business Idea")
                .font(.title2)
                .foregroundColor(.white)

            Spacer()

            TextField("Your idea...", text: $viewModel.idea, axis: .vertical)
                .lineLimit(5...7)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.horizontal)
                .onChange(of: viewModel.idea) {
                    // Trim whitespace and enforce character limit
                    viewModel.idea = viewModel.idea.trimmingCharacters(in: .whitespacesAndNewlines)
                    if viewModel.idea.count > 200 {
                        viewModel.idea = String(viewModel.idea.prefix(200))
                    }
                }

            // Character count
            Text("\(viewModel.idea.count)/200")
                .foregroundColor(.gray)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)

            Spacer()

            // "Next" Button - Only enabled if input is at least 5 characters (excluding spaces)
            NavigationLink(destination: SelectCategoryView(viewModel: viewModel)) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isIdeaValid ? Color.red : Color.gray)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding()
            }
            .disabled(!isIdeaValid)
        }
        .background(LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }

    /// Computed property: Checks if the input has at least 5 valid characters
    private var isIdeaValid: Bool {
        viewModel.idea.trimmingCharacters(in: .whitespacesAndNewlines).count >= 5
    }
}

#Preview {
    IdeaInputView(viewModel: BusinessNameViewModel())
}

