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

    @State private var isUnlocked = false // 🔓 Unlocks after ad watch

    var body: some View {
        ZStack {
            // ✅ Background Gradient
            AnimatedMeshGradient()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // ✅ Title
                Text("Generated Names")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                if isUnlocked {
                    // ✅ Unlocked: Show Name Cards
                    ScrollView {
                        ForEach(viewModel.generatedNames) { name in
                            Button(action: {
                                viewModel.selectedBusinessName = name
                                navigationManager.navigateToStep(.nameInfo)
                            }) {
                                NameListCard(name: name)
                            }
                            .buttonStyle(PlainButtonStyle()) // Removes default button style
                            .padding(.horizontal, 16)
                        }
                    }
                } else {
                    // ✅ Locked: Show Blurred Overlay
                    BlurredOverlay()
                        .padding(.horizontal, 16)
                }
            }

            // ✅ Watch Ad Button Centered Properly
            if !isUnlocked {
                VStack {
                    Button(action: {
                        watchAdToUnlock()
                    }) {
                        HStack {
                            Text("Watch Ad")
                                .font(.headline)
                                .fontWeight(.bold)
                            Image(systemName: "play.fill") // ▶️ Icon
                        }
                        .frame(width: 200, height: 50)
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }

                    Text("To Unlock all the names")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 4)
                }
                .frame(maxHeight: .infinity) // ✅ Perfectly Centers in the Middle
            }
        }
    }

    // ✅ Simulated Ad Watch Function
    func watchAdToUnlock() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                isUnlocked = true
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
                .frame(height: 200)

   
        }
    }
}

// ✅ Frosted Glass Name Card
private struct NameListCard: View {
    let name: BusinessName

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1)) // ✅ Frosted Glass Effect
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .blur(radius: 10)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)

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

            // ✅ Chevron Icon (Navigation Indicator)
            Image(systemName: "chevron.right")
                .font(.title2)
                .foregroundColor(.white.opacity(0.6))
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
