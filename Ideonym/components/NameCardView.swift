//
//  NameCardView.swift
//  ideonym
//
//  Created by GK Naidu on 16/02/25.
//

import SwiftUI

struct NameCardView: View {
    let name: BusinessName

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.2), // ✅ Subtle frosted white
                        Color.black.opacity(0.8)  // ✅ Light frosted black for depth
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial) // ✅ Now applies blur only inside rounded edges
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1) // ✅ Subtle outline
            )
            .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 4) // ✅ Depth effect
            .overlay(content: {
                VStack(alignment: .leading, spacing: 6) {
                    // ✅ Business Name
                    Text(name.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.7)) // ✅ Ensures proper contrast

                    // ✅ Tagline (If Available)
                    if !name.tagline.isEmpty {
                        Text(name.tagline)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading) // ✅ Left-aligned text
            })
            .frame(maxWidth: 600, minHeight: 90) // ✅ Ensures scalable layout
            .padding(.horizontal, 16)
    }
}

#Preview {
    NameCardView(name: BusinessName(name: "GradientGlass Inc.", tagline: "Where Ideas Shine in Style"))
}
