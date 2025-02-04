//
//  NameListView.swift
//  ideonym
//
//  Created by GK Naidu on 02/02/25.
//
import SwiftUI

struct NameListView: View {
    @ObservedObject var viewModel: BusinessNameViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Generating...")
                    .foregroundColor(.white)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            } else {
                ScrollView {
                    ForEach(viewModel.generatedNames) { name in
                        VStack(alignment: .leading) {
                            Text(name.name)
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                            Text(name.tagline)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
            }

            Button(action: {
                viewModel.isLoading = true
                viewModel.generateBusinessNames {
                    DispatchQueue.main.async {
                        viewModel.isLoading = false // Hide progress after fetching names
                    }
                }
            }) {
                Text("Generate Again")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .background(LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    NameListView(viewModel: BusinessNameViewModel())
}
