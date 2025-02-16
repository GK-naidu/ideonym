//
//  SelectCategoryView.swift
//  ideonym
//
//  Created by GK Naidu on 04/02/25.
//

import SwiftUI

struct SelectCategoryView: View {
    @ObservedObject var viewModel: BusinessNameViewModel
    let onNext: () -> Void
    @FocusState private var isTextFieldFocused: Bool
    let categories = ["Tech", "Business", "Fashion", "Health", "Gaming", "Other"]
    @State private var customCategory: String = ""

    var body: some View {
        VStack {
            Spacer(minLength: isTextFieldFocused ? 0 : 40) // Ensure spacing when keyboard is hidden
            
            Text("Select a Category")
                .font(.title2)
                .foregroundColor(.white)
            
            VStack {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        viewModel.selectedCategory = category
                        if category == "Other" {
                            isTextFieldFocused = true
                        } else {
                            customCategory = ""
                            isTextFieldFocused = false
                        }
                    }) {
                        HStack {
                            Text(category).foregroundColor(.white)
                            Spacer()
                            if viewModel.selectedCategory == category {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.red)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                    }
                }

                if viewModel.selectedCategory == "Other" {
                    TextField("Enter custom category...", text: $customCategory)
                        .focused($isTextFieldFocused)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                        .transition(.opacity)
                        .animation(.easeInOut, value: viewModel.selectedCategory)
                }
            }
            .padding()
            
            Spacer()

            Button(action: {
                viewModel.selectedCategory = (viewModel.selectedCategory == "Other") ? customCategory : viewModel.selectedCategory
                onNext()
            }) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        (viewModel.selectedCategory == "Other" && customCategory.isEmpty) || viewModel.selectedCategory.isEmpty
                        ? Color.gray : Color.white.opacity(0.7)
                    )
                    .cornerRadius(12)
                    .foregroundColor(.black)
                    .padding()
            }
            .disabled((viewModel.selectedCategory == "Other" && customCategory.isEmpty) || viewModel.selectedCategory.isEmpty)
            .safeAreaInset(edge: .bottom) { // New Modern Approach
                Color.clear.frame(height: isTextFieldFocused ? 20 : 0) // Add spacing only when keyboard is active
            }
        }
        .background(Color.clear)
        .onChange(of: isTextFieldFocused) {
            withAnimation(.easeInOut(duration: 0.2)) {
                // Adjust layout dynamically
            }
        }
    }
}

