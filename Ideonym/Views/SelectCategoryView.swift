//
//  SelectCategoryView.swift
//  ideonym
//
//  Created by GK Naidu on 04/02/25.
//

import SwiftUI

struct SelectCategoryView: View {
    @ObservedObject var viewModel: BusinessNameViewModel
    let onNext: () -> Void // ✅ Now controlled externally
    @FocusState private var isTextFieldFocused: Bool
    let categories = ["Tech", "Business", "Fashion", "Health", "Gaming", "Other"]
    @State private var customCategory: String = ""
    var body: some View {
        VStack {
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

                // ✅ Show TextField only when "Other" is selected
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
                    .foregroundColor(.blue)
                    .padding()
            }
            .disabled((viewModel.selectedCategory == "Other" && customCategory.isEmpty) || viewModel.selectedCategory.isEmpty)
            .padding()
        }
        .background(LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

