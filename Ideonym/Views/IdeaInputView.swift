//
//  IdeaInputView.swift
//  ideonym
//
//  Created by GK Naidu on 02/02/25.
//

import SwiftUI

struct IdeaInputView: View {
    @ObservedObject var viewModel: BusinessNameViewModel
    
    var body: some View {
        VStack {
            Text("Enter Your Business Idea")
                .font(.title2)
                .foregroundColor(.white)
            
            TextField("Your idea...", text: $viewModel.idea)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.horizontal)
                .onChange(of: viewModel.idea) {
                    if viewModel.idea.count > 200 {
                        viewModel.idea = String(viewModel.idea.prefix(200))
                    }
                }
            
            Text("\(viewModel.idea.count)/200")
                .foregroundColor(.gray)
                .font(.caption)
            
            Spacer()
            
            NavigationLink(destination: SelectCategoryView(viewModel: viewModel)) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.idea.isEmpty ? Color.gray : Color.red)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding()
            }
            .disabled(viewModel.idea.isEmpty)
        }
        .background(LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    IdeaInputView(viewModel: BusinessNameViewModel())
}

#Preview {
    IdeaInputView(viewModel: BusinessNameViewModel())
}

