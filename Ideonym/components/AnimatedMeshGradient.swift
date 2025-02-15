//
//  AnimatedMeshGradient.swift
//  ideonym
//
//  Created by GK Naidu on 15/02/25.
//

import SwiftUI

struct AnimatedMeshGradient: View {
    var body: some View {
        LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            .opacity(0.9) // Slight fade effect
    }
}

#Preview {
    AnimatedMeshGradient()
}
