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
    let icons: [String] // ✅ Add icons for each option (Make sure these match asset names)
    @Binding var selectedOption: String
    let onNext: () -> Void
    
    var body: some View {
        ZStack {
            // ✅ Fullscreen Background Gradient
            AnimatedMeshGradient()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // ✅ Title
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // ✅ Scrollable Options Grid
                ScrollView {
                    VStack(spacing: 16) {
                        let cardSize = (UIScreen.main.bounds.width - 64) / 2 // Adjust card size dynamically
                        
                        ForEach(0..<options.count / 2, id: \.self) { rowIndex in
                            HStack(spacing: 16) {
                                ForEach(0..<2, id: \.self) { columnIndex in
                                    let index = rowIndex * 2 + columnIndex
                                    if index < options.count {
                                        Button(action: {
                                            selectedOption = options[index]
                                        }) {
                                            VStack(spacing: 10) {
                                                Image(icons[index]) // ✅ Load icon from assets
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 50, height: 50) // Icon size
                                                
                                                VStack {
                                                    let parts = options[index].split(separator: "&").map { String($0) }
                                                    if parts.count == 2 {
                                                        Text(parts[0])
                                                            .font(.headline)
                                                            .foregroundColor(.white)
                                                        Text("&")
                                                            .font(.headline)
                                                            .foregroundColor(.gray.opacity(0.8))
                                                        Text(parts[1])
                                                            .font(.headline)
                                                            .foregroundColor(.white)
                                                    } else {
                                                        Text(options[index]) // Fallback for single-word options
                                                            .font(.headline)
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                            }
                                            .frame(width: cardSize, height: cardSize)
                                            .background(selectedOption == options[index] ? Color.purple.opacity(0.7) : Color.white.opacity(0.1))
                                            .cornerRadius(20)
                                            .shadow(color: selectedOption == options[index] ? Color.purple.opacity(0.6) : Color.clear, radius: 8)
                                        }
                                    }
                                }
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
