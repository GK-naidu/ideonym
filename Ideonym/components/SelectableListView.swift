//
//  SelectableListView.swift
//  ideonym
//
//  Created by GK Naidu on 16/02/25.
//

import SwiftUI

struct SelectableListView: View {
    let title: String
    let options: [String]
    @Binding var selectedOption: String
    @FocusState private var isTextFieldFocused: Bool
    let onNext: () -> Void

    @State private var customInput: String = ""

    var body: some View {
        ScrollView {
            VStack {
                Text(title)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.top, 40)

                VStack {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedOption = option
                            if option == "Other" {
                                isTextFieldFocused = true
                            } else {
                                customInput = ""
                                isTextFieldFocused = false
                            }
                        }) {
                            HStack {
                                Text(option)
                                    .foregroundColor(.white)
                                Spacer()
                                if selectedOption == option {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }

                    if selectedOption == "Other" {
                        TextField("Enter custom \(title.lowercased())...", text: $customInput)
                            .focused($isTextFieldFocused)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                            .transition(.opacity)
                            .animation(.easeInOut, value: selectedOption)
                    }
                }
                .padding()

                Spacer()

                Button(action: {
                    selectedOption = (selectedOption == "Other") ? customInput : selectedOption
                    onNext()
                }) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            (selectedOption == "Other" && customInput.isEmpty) || selectedOption.isEmpty
                            ? Color.gray : Color.white.opacity(0.7)
                        )
                        .cornerRadius(12)
                        .foregroundColor(.black)
                        .padding()
                }
                .disabled((selectedOption == "Other" && customInput.isEmpty) || selectedOption.isEmpty)
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: isTextFieldFocused ? 20 : 0)
                }
            }
            .background()
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: isTextFieldFocused) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    // Smooth layout adjustments when keyboard appears
                }
            }
        }
    }
}

#Preview {
    SelectableListView(
        title: "Select a Category",
        options: ["Tech", "Business", "Fashion", "Health", "Gaming", "Other"],
        selectedOption: .constant("Tech"), // ✅ Use `.constant()` for @Binding preview
        onNext: {} // ✅ Provide an empty closure for preview
    )
}
