//
//  MeshGradientOutlineModifier.swift
//  ideonym
//
//  Created by GK Naidu on 09/03/25.
//

import SwiftUI

struct MeshGradientOutlineModifier: ViewModifier {
    @State private var animatedGradient = [Color.cyan, Color.white, Color.pink, Color.orange]

    func body(content: Content) -> some View {
        content
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
            .frame(width: 250, height: 55)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: animatedGradient),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .blur(radius: 1.5)
                    .onAppear {
                        animateGradient()
                    }
            )
    }

    // 🔥 Faster & More Vivid Color Animation
    private func animateGradient() {
        let colorSets: [[Color]] = [
            [Color.cyan, Color.white, Color.pink, Color.orange],
            [Color.red, Color.yellow, Color.blue, Color.white],
            [Color.indigo, Color.pink, Color.teal, Color.white]
        ]

        var index = 0

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.4)) {
                animatedGradient = colorSets[index]
            }
            index = (index + 1) % colorSets.count
        }
    }
}

// ✅ **Extension for Easy Use**
extension View {
    func meshGradientOutlineStyle() -> some View {
        self.modifier(MeshGradientOutlineModifier())
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Button(action: {}) {
        Text("Watch Ad") // ✅ Wrap inside a Button
    }
    .meshGradientOutlineStyle()
    .padding()
}
