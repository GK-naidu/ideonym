//
//  IdeaInputView.swift
//  ideonym
//
//  Created by GK Naidu on 02/02/25.
//

import SwiftUI

struct IdeaInputView: View {
    @ObservedObject var viewModel: BusinessNameViewModel
    let onNext: () -> Void
    @FocusState private var isTextFieldFocused: Bool // ✅ Auto-focus text field

    var body: some View {
        GeometryReader { geometry in // ✅ Dynamic layout for all screen sizes
            ZStack {
                // Fullscreen Background Gradient
                AnimatedMeshGradient()
                    .edgesIgnoringSafeArea(.all)

                // Main Content
                VStack(alignment: .leading) {
                    // ✅ Left-aligned Title
                    Text("Enter Your Idea")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8) // ✅ Spacing from text field

                    // ✅ Styled Text Field with Outline & Drop Shadow
                    TextField("Your idea...", text: $viewModel.idea, axis: .vertical)
                        .lineLimit(5...7)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.9), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 4)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .focused($isTextFieldFocused)
                        .frame(height: 120)
                        .padding(.horizontal, 20)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    isTextFieldFocused = false
                                }
                                .foregroundColor(.blue)
                            }
                        }

                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }
            
        }
    }
}


#Preview {
    IdeaInputView(viewModel: BusinessNameViewModel(), onNext: {})
}
