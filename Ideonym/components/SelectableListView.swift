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
        GeometryReader { geometry in
            ZStack {
                // ✅ Fullscreen Background for All Devices
                AnimatedMeshGradient()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    ScrollView {
                        VStack(alignment: .center, spacing: 12) {
                            // ✅ Title
                            Text(title)
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(.top, 40)
                                .frame(maxWidth: 600, alignment: .center) // ✅ Keeps title width controlled

                            // ✅ Options List
                            VStack(spacing: 12) {
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
                                        .frame(maxWidth: min(geometry.size.width - 40, 600)) // ✅ Prevents stretching on iPad
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(10)
                                    }
                                }

                                // ✅ TextField for Custom Input
                                if selectedOption == "Other" {
                                    TextField("Enter custom \(title.lowercased())...", text: $customInput)
                                        .focused($isTextFieldFocused)
                                        .padding()
                                        .frame(maxWidth: min(geometry.size.width - 40, 600)) // ✅ Keeps input box reasonable
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(10)
                                        .foregroundColor(.blue)
                                        .padding(.top, 10)
                                        .transition(.opacity)
                                        .animation(.easeInOut, value: selectedOption)
                                        .toolbar { // ✅ Fixes keyboard toolbar issue
                                            ToolbarItemGroup(placement: .keyboard) {
                                                Spacer()
                                                Button("Done") {
                                                    isTextFieldFocused = false
                                                }
                                                .foregroundColor(.blue)
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .frame(maxWidth: 600)
                        .padding(.bottom, 100) // ✅ Prevents clipping when scrolling
                    }
                    .scrollDismissesKeyboard(.interactively)

                    Spacer()

                    // ✅ Next Button (Fixed at Bottom)
                    Button(action: {
                        selectedOption = (selectedOption == "Other") ? customInput : selectedOption
                        onNext()
                    }) {
                        Text("Next")
                            .frame(maxWidth: min(geometry.size.width - 40, 600)) // ✅ Controls width on iPad
                            .padding()
                            .background(
                                (selectedOption == "Other" && customInput.isEmpty) || selectedOption.isEmpty
                                ? Color.gray : Color.white.opacity(0.7)
                            )
                            .cornerRadius(12)
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 20)) // ✅ Keeps it properly positioned
                    .disabled((selectedOption == "Other" && customInput.isEmpty) || selectedOption.isEmpty)
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center) // ✅ Ensures full-screen scaling
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
