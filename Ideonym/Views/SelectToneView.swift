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
        VStack {
            Text("Select a Tone")
                .font(.title2)
                .foregroundColor(.white)

            VStack {
                ForEach(tones, id: \.self) { tone in
                    Button(action: {
                        viewModel.selectedTone = tone
                        if tone == "Other" {
                            isTextFieldFocused = true // ✅ Auto-focus input when "Other" is selected
                        } else {
                            customTone = "" // ✅ Clear input if a preset tone is chosen
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

                // ✅ Show TextField only when "Other" is selected
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

            // ✅ Now correctly calls the `onGenerate` function
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
                    .foregroundColor(.blue)
                    .padding()
            }
            .disabled((viewModel.selectedTone == "Other" && customTone.isEmpty) || viewModel.selectedTone.isEmpty)
            .padding()
        }
        .background(LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}


