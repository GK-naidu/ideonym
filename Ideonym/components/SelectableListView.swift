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
    let icons: [String]
    @Binding var selectedOption: String
    let onNext: () -> Void

    var body: some View {
        ZStack {
            // ✅ Fullscreen Animated Gradient Background
            AnimatedMeshGradient()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                // ✅ Title with Consistent Styling
                Spacer().frame(height: 20)
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                // ✅ Scrollable Options Grid
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 14), count: 2), spacing: 14) {
                        ForEach(options.indices, id: \.self) { index in
                            OptionCard(
                                title: options[index],
                                iconName: icons[index],
                                isSelected: selectedOption == options[index]
                            )
                            .onTapGesture {
                                selectedOption = options[index]
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 120)
                    .scrollIndicators(.never)
                }
            }
        }
    }
}

// ✅ **Refined Option Card Component**
struct OptionCard: View {
    let title: String
    let iconName: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding(.top, 10)

            Text(title)
                .font(.subheadline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .frame(width: 150, height: 150)
        .background(Color.black.opacity(isSelected ? 0.3 : 0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isSelected ? AnyShapeStyle(
                        LinearGradient(
                            colors: [Color.cyan, Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    ) : AnyShapeStyle(Color.white.opacity(0.2)),
                    lineWidth: isSelected ? 3 : 1
                )
                .blur(radius: isSelected ? 1.5 : 0)
        )
        .shadow(color: isSelected ? Color.cyan.opacity(0.5) : Color.clear, radius: 10)
    }
}

// ✅ **Preview**
#Preview {
    SelectableListView(
        title: "Select a Tone",
        options: [
            "Professional & Corporate", "Friendly & Fun", "Innovative & Modern", "Luxury & Premium",
            "Bold & Strong", "Inspirational & Uplifting", "Minimalist & Elegant", "Playful & Quirky"
        ],
        icons: [
            "icon_professional", "icon_friendly", "icon_innovative", "icon_luxury",
            "icon_bold", "icon_inspirational", "icon_minimalist", "icon_playful"
        ],
        selectedOption: .constant("Professional & Corporate"),
        onNext: {}
    )
}
