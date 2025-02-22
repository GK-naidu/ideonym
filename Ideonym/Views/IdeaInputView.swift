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
                                .stroke(Color.white.opacity(0.5), lineWidth: 1) // ✅ Visible Outline
                        )
                        .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 4) // ✅ Drop Shadow
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .focused($isTextFieldFocused) // ✅ Focus Control
                        .frame(height: 120) // ✅ Fixed height for text field
                        .padding(.horizontal, 20)
                        .toolbar { // ✅ Keyboard Toolbar
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer() // Pushes the button to the right
                                Button("Done") {
                                    isTextFieldFocused = false // ✅ Dismiss keyboard
                                }
                                .foregroundColor(.blue)
                            }
                        }

                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }
            .task {
                // ✅ Auto-focus Text Field After 2 Seconds
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                isTextFieldFocused = true
            }
        }
    }
}



