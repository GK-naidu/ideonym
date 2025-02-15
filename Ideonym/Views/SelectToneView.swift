//
//  SelectToneView.swift
//  ideonym
//
//  Created by GK Naidu on 04/02/25.
//
import SwiftUI

struct SelectToneView: View {
    @ObservedObject var viewModel: BusinessNameViewModel
    let onGenerate: () -> Void // ✅ Added this parameter

    let tones = ["Professional", "Friendly", "Innovative", "Luxury", "Other"]
    
    var body: some View {
        VStack {
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

            // ✅ Now correctly calls the `onGenerate` function
            Button(action: onGenerate) {
                Text("Generate")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.selectedTone.isEmpty ? Color.gray : Color.red)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding()
            }
            .disabled(viewModel.selectedTone.isEmpty)
        }
        .background(LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}


