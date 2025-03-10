//
//  NameListView.swift
//  ideonym
//
//  Created by GK Naidu on 02/02/25.
//

import SwiftUI

struct NameListView: View {
    @ObservedObject var viewModel: BusinessNameViewModel
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        ZStack {
            AnimatedMeshGradient()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Spacer().frame(height: 20)
                Text("Generated Names")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                if viewModel.hasWatchedAdForCurrentBatch {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.generatedNames) { name in
                                Button(action: {
                                    viewModel.selectedBusinessName = name
                                    navigationManager.navigateToStep(.nameInfo)
                                }) {
                                    NameListCard(name: name)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal, 16)
                            }

                            // ✅ Generate More Names Button (Only visible after unlock)
                            Button(action: {
                                viewModel.generateBusinessNames {}
                            }) {
                                Text("Generate More Names")
                                    .frame(width: 250, height: 50)
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 20)
                        }.padding()
                    }
                } else {
                    BlurredOverlay()
                        .padding(.horizontal, 16)
                }
            }

            // ✅ Show Watch Ad Button Only When Needed
            if !viewModel.hasWatchedAdForCurrentBatch && !viewModel.generatedNames.isEmpty {
                VStack {
                    Button(action: {
                        watchAdToUnlock()
                    }) {
                        HStack {
                            Text("Watch Ad")
                                .font(.headline)
                                .fontWeight(.bold)
                            Image(systemName: "play.fill")
                        }
                        .frame(width: 300, height: 70)
                        .background(Color.black)
                        .modifier(MeshGradientOutlineModifier())
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }

                    Text("To Unlock all the names")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 4)
                }
                .frame(maxHeight: .infinity)
            }
        }
    }

    // ✅ Watch Ad Function (Modifies ViewModel)
    func watchAdToUnlock() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                viewModel.hasWatchedAdForCurrentBatch = true
            }
        }
    }
}

// ✅ Blurred Overlay View (Locks All Names)
private struct BlurredOverlay: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.3))
                .blur(radius: 10)

   
        }
    }
}

// ✅ Frosted Glass Name Card
private struct NameListCard: View {
    let name: BusinessName

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.2)) // ✅ Frosted Glass Effect
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white, lineWidth: 1)
                        
                )
          

            VStack(alignment: .leading, spacing: 6) {
                Text(name.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer().frame(height: 10)

                Text(name.tagline)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .bottomLeading)
            }
            .padding()


        }
        .frame(height: 100) // Keeps cards consistent
    }
}

// ✅ Preview
#Preview {
    let mockViewModel = BusinessNameViewModel()
    let mockNavigationManager = NavigationManager()

    mockViewModel.generatedNames = [
        BusinessName(name: "Nexova", tagline: "A futuristic name for innovative brands.", tags: ["Technology", "Innovation"]),
        BusinessName(name: "LexiCraft", tagline: "Crafting names with precision and creativity.", tags: ["Creative", "Branding"]),
        BusinessName(name: "BrandNova", tagline: "Ignite your brand with a powerful identity.", tags: ["Marketing", "Startup"]),
        BusinessName(name: "IdeaForge", tagline: "Shaping your ideas into reality.", tags: ["Business", "Consulting"]),
        BusinessName(name: "Visionary", tagline: "For those who think ahead.", tags: ["Innovation", "Growth"]),
    ]

    return NameListView(viewModel: mockViewModel)
        .environmentObject(mockNavigationManager)
}
