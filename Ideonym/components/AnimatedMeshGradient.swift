//
//  AnimatedMeshGradient.swift
//  ideonym
//
//  Created by GK Naidu on 15/02/25.
//

import SwiftUI

struct AnimatedMeshGradient: View {
    @State private var xOffset: Float = 0.5
    @State private var yOffset: Float = 0.5

    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                SIMD2<Float>(0, 0), SIMD2<Float>(1, 0), SIMD2<Float>(2, 0),
                SIMD2<Float>(0, 1), SIMD2<Float>(xOffset, yOffset), SIMD2<Float>(2, 1),
                SIMD2<Float>(0, 2), SIMD2<Float>(1, 2), SIMD2<Float>(2, 2)
            ],
            colors: [
                .black , .purple, .red,
                 .indigo, .black
            ]
        )
        .ignoresSafeArea()
        .onAppear {
            startAnimation()
        }
    }

    /// **Starts a smooth animation with minimal CPU overhead**
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
            xOffset = 0.8
            yOffset = 0.3
        }
    }
}

#Preview {
    AnimatedMeshGradient()
}
