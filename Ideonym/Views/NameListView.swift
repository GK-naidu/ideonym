//
//  NameListView.swift
//  ideonym
//
//  Created by GK Naidu on 02/02/25.
//

import SwiftUI

struct NameListView: View {
    @ObservedObject var viewModel: NameViewModel
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Fetching Names...")
                        .padding()
                } else {
                    List(viewModel.businessNames) { name in
                        BusinessNameRow(name: name)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Generated Names")
            .task {
                await viewModel.fetchBusinessNames()
            }
        }
    }
}

// MARK: - Private Row View
private struct BusinessNameRow: View {
    let name: BusinessName
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(name.name)
                .font(.headline)
            
            HStack {
                SocialMediaAvailabilityView(platform: "Twitter", isAvailable: name.availability.socialMedia.twitter)
                SocialMediaAvailabilityView(platform: "YouTube", isAvailable: name.availability.socialMedia.youtube)
                SocialMediaAvailabilityView(platform: "Instagram", isAvailable: name.availability.socialMedia.instagram)
            }
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Private Social Media Status View
private struct SocialMediaAvailabilityView: View {
    let platform: String
    let isAvailable: Bool

    var body: some View {
        HStack {
            Image(systemName: isAvailable ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isAvailable ? .green : .red)
            Text(platform)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NameListView(viewModel: NameViewModel())
}
