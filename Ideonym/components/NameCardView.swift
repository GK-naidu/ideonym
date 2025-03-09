//
//  NameCardView.swift
//  ideonym
//
//  Created by GK Naidu on 16/02/25.
//

import SwiftUI

struct NameCardView: View {
    let name: BusinessName
    let isCompact: Bool // Determines if it's used in a list or full info view
    let onLikeTapped: (() -> Void)? = nil
    @State private var isFavorited: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var renderedImage: UIImage?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .blur(radius: 10)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 4)

            VStack(spacing: 12) {
                Text(name.name)
                    .font(isCompact ? .title3 : .largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(name.tagline)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(isCompact ? 1 : nil)
            }
            .padding()
            
            if isCompact {
                HStack {
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.6))
                        .padding()
                }
            }
        }
    }
}



struct ActionButton: View {
    let icon: String
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 22)) // Larger icon size for visibility
                    .foregroundColor(.white)

                Text(text)
                    .font(.system(size: 14, weight: .medium)) // Uniform text size
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8) // Prevents text from breaking
            }
            .frame(width: 80, height: 80) // Equal button sizing
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

// ✅ Reusable Like Button
struct LikeButton: View {
    @Binding var isFavorited: Bool
    var action: () -> Void

    var body: some View {
        Button(action: {
            isFavorited.toggle()
            action()
        }) {
            VStack {
                Image(systemName: isFavorited ? "heart.fill" : "heart")
                    .font(.title)
                    .foregroundColor(isFavorited ? .red : .white)
                Text("Like")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .padding()
            .frame(width: 100, height: 100)
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

// ✅ Preview
#Preview {
    NameCardView(name: BusinessName(name: "Nexova", tagline: "A futuristic name for innovative brands.", tags: ["Technology", "Innovation"]), isCompact: false)
}


// Share Sheet for iOS
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        // ✅ Force Dark Mode on Share Sheet
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.backgroundColor = UIColor.black
        }

        return activityVC
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Background View for Rendering Images
struct RenderingView: UIViewRepresentable {
    @Binding var image: UIImage?

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        DispatchQueue.main.async {
            self.image = captureScreen(view: view)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    private func captureScreen(view: UIView) -> UIImage? {
        let size = view.bounds.size
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}

#Preview {
    NameCardView(name: BusinessName(name: "Nexova", tagline: "A modern, tech-forward name perfect for innovation-focused brands", tags: ["Technology", "Innovative"]), isCompact: true)
}
