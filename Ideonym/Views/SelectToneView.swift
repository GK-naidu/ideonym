//
//  SelectToneView.swift
//  ideonym
//
//  Created by GK Naidu on 04/02/25.
//
import SwiftUI

struct SelectToneView: View {
    @ObservedObject var viewModel: BusinessNameViewModel
    let onGenerate: () -> Void // ✅ Function triggered when "Generate" is pressed

    let tones = ["Professional", "Friendly", "Innovative", "Luxury", "Other"]
    @State private var customTone: String = ""
    @FocusState private var isTextFieldFocused: Bool // ✅ Auto-focus state

    var body: some View {
        GeometryReader { geometry in // ✅ Use GeometryReader for dynamic layout
            VStack {
                Spacer(minLength: isTextFieldFocused ? 0 : 40) // Prevent UI jump

                Text("Select a Tone")
                    .font(.title2)
                    .foregroundColor(.white)

                VStack {
                    ForEach(tones, id: \.self) { tone in
                        Button(action: {
                            viewModel.selectedTone = tone
                            if tone == "Other" {
                                isTextFieldFocused = true
                            } else {
                                customTone = ""
                                isTextFieldFocused = false
                            }
                        }) {
                            HStack {
                                Text(tone).foregroundColor(.white)
                                Spacer()
                                if viewModel.selectedTone == tone {
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }

                    if viewModel.selectedTone == "Other" {
                        TextField("Enter custom tone...", text: $customTone)
                            .focused($isTextFieldFocused)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                            .transition(.opacity)
                            .animation(.easeInOut, value: viewModel.selectedTone)
                    }
                }
                .padding()

                Spacer()

                Button(action: {
                    viewModel.selectedTone = (viewModel.selectedTone == "Other") ? customTone : viewModel.selectedTone
                    onGenerate()
                }) {
                    Text("Generate")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            (viewModel.selectedTone == "Other" && customTone.isEmpty) || viewModel.selectedTone.isEmpty
                            ? Color.gray : Color.white.opacity(0.7)
                        )
                        .cornerRadius(12)
                        .foregroundColor(.black)
                        .padding()
                }
                .disabled((viewModel.selectedTone == "Other" && customTone.isEmpty) || viewModel.selectedTone.isEmpty)
                .padding(.bottom, isTextFieldFocused ? geometry.safeAreaInsets.bottom + 20 : 0) // ✅ Prevent UI jump
            }
            .frame(width: geometry.size.width, height: geometry.size.height) // ✅ Ensures layout adapts to screen size
            .background(Color.clear) // Keeps AnimatedMeshGradient in ViewNavigationFlow
            .onChange(of: isTextFieldFocused) { // ✅ Updated for iOS 17+
                withAnimation(.easeInOut(duration: 0.2)) {
                    // Smooth layout adjustments when keyboard appears
                }
            }
        }
    }
}


