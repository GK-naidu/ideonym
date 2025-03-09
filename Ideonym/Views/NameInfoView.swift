//
//  NameInfoView.swift
//  ideonym
//
//  Created by GK Naidu on 22/02/25.
//

import SwiftUI

struct NameInfoView: View {
    let name: BusinessName
    @StateObject private var viewModel = BusinessNameViewModel()
    @State private var showShareSheet: Bool = false

    var body: some View {
        ZStack {
            AnimatedMeshGradient()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                
                NameCardView(name: name, isCompact: false)
                    .padding()
                    .frame(maxHeight: 300)

                // ✅ Action Buttons (Save, Share, Copy, Like) - Proper Sizing
                HStack(spacing: 12) {
                    // ✅ Save Button
                    ActionButton(icon: "photo", text: "Save") {
                        viewModel.saveImage(name) //  Calls ViewModel function
                    }

                    ActionButton(icon: "square.and.arrow.up", text: "Share") {
                        viewModel.shareImage(for: name) {
                            if let image = viewModel.renderedImage {
                                ShareSheetManager.shared.share(items: [image])
                            }
                        }
                    }

                    // ✅ Copy Button
                    ActionButton(icon: "doc.on.doc", text: "Copy") {
                        viewModel.copyText(name.name) // ✅ Calls ViewModel function
                    }

                    // ✅ Like Button
                    ActionButton(icon: "heart", text: "Like") {
                        viewModel.toggleFavorite(name: name.name)
                    }
                }
                .padding(.horizontal, 20)

                

                // ✅ Domain Availability Button (Rounded)
                Button(action: {
                    viewModel.checkDomainAvailability(for: name.name)
                }) {
                    HStack {
                        Image(systemName: "globe")
                            .font(.title2)
                        Text(viewModel.domainStatus ?? (viewModel.isCheckingDomain ? "Checking..." : "Check Domain Availability"))
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }.alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

// ✅ Preview
#Preview {
    NameInfoView(name: BusinessName(name: "Nexova", tagline: "A futuristic name for innovative brands.", tags: ["Technology", "Innovation"]))
}
