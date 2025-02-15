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

    let categories = ["Tech", "Business", "Fashion", "Health", "Gaming", "Other"]

    var body: some View {
        VStack {
            Text("Select a Category")
                .font(.title2)
                .foregroundColor(.white)

            VStack {
                ForEach(categories, id: \.self) { category in
                    Button(action: { viewModel.selectedCategory = category }) {
                        HStack {
                            Text(category)
                                .foregroundColor(.white)
                            Spacer()
                            if viewModel.selectedCategory == category {
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

            Button(action: onNext) { // ✅ Navigation logic moved outside the view
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.selectedCategory.isEmpty ? Color.gray : Color.red)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding()
            }
            .disabled(viewModel.selectedCategory.isEmpty)
        }
        .background(LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

