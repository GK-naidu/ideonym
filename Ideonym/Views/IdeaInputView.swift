//
//  IdeaInputView.swift
//  ideonym
//
//  Created by GK Naidu on 02/02/25.
//

import SwiftUI

struct IdeaInputView: View {
    @ObservedObject var viewModel: BusinessNameViewModel
    let onNext: () -> Void // ✅ Navigation is now controlled from ViewNavigationFlow

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

            Spacer()

            Button(action: onNext) { // ✅ Navigation logic moved outside the view
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.idea.count >= 5 ? Color.white.opacity(0.7) : Color.gray)
                    .cornerRadius(12)
                    .foregroundColor(.black)
                    .padding()
            }
            .disabled(viewModel.idea.count < 5)
        }
        .background(AnimatedMeshGradient())
    }
}



