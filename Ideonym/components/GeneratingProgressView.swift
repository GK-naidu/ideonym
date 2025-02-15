//
//  GeneratingProgressView.swift
//  ideonym
//
//  Created by GK Naidu on 15/02/25.
//

import SwiftUI

struct GeneratingProgressView: View {
    var body: some View {
        ZStack {
            // ✅ Full-screen background for Mesh Gradient
            LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView("Generating Names...")
                .foregroundColor(.white)
                .scaleEffect(1.5)
                .padding()
        }
    }
}

#Preview {
    GeneratingProgressView()
}
