//
//  GeneratingProgressView.swift
//  ideonym
//
//  Created by GK Naidu on 15/02/25.
//

import SwiftUI

struct GeneratingProgressView: View {
    // Timer to animate mesh gradient control points
    @State private var timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()

    // Animated Control Points for MeshGradient
    @State private var meshPoints: [SIMD2<Float>] = [
        SIMD2<Float>(0, 0), SIMD2<Float>(1, 0), SIMD2<Float>(2, 0),
        SIMD2<Float>(0, 1), SIMD2<Float>(1, 1), SIMD2<Float>(2, 1),
        SIMD2<Float>(0, 2), SIMD2<Float>(1, 2), SIMD2<Float>(2, 2)
    ]

    var body: some View {
        ZStack {
            // Background with animated mesh gradient
            MeshGradient(
                width: 3,
                height: 3,
                points: meshPoints,
                colors: [
                    .black, .purple, .red,
                    .indigo, .black
                ]
            )
            .frame(width: 260, height: 260) // Slightly larger to enhance glow
            .clipShape(Circle())
            .blur(radius: 35) // Balanced soft glow effect
            .shadow(color: Color.red.opacity(0.4), radius: 40) // Outer glow
            .shadow(color: Color.purple.opacity(0.4), radius: 20) // Inner subtle glow
            .onReceive(timer) { _ in
                animateMeshPoints()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea()) // Dark background for contrast
    }

    // Function to animate mesh gradient control points subtly
    private func animateMeshPoints() {
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            meshPoints = meshPoints.map { point in
                SIMD2<Float>(
                    point.x + Float.random(in: -0.08...0.08), // Faster motion
                    point.y + Float.random(in: -0.08...0.08)
                )
            }
        }
    }
}

#Preview {
    GeneratingProgressView()
}
