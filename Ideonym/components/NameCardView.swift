//
//  NameCardView.swift
//  ideonym
//
//  Created by GK Naidu on 16/02/25.
//

import SwiftUI

struct NameCardView: View {
    let name: BusinessName
    @State private var isFavorited: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var renderedImage: UIImage?
    @State private var isRendering: Bool = false
    // ✅ Toast State Variables
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""

    var body: some View {
        ZStack {
            // ✅ Card Background (Glassmorphism Style)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .background(
                    Color.black.opacity(0.4)
                        .blur(radius: 10)
                )
                .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40) // ✅ Square Shape
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)

            VStack(spacing: 16) {
                // ✅ Generated Name (Main Highlight)
                Text(name.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)

                // ✅ Name Description (Tagline - Secondary Highlight)
                Text(name.tagline)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)

                // ✅ Display Tags (Category & Tone)
                if !name.safeTags.isEmpty {
                    HStack {
                        ForEach(name.safeTags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.purple.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }
                }

                Spacer()

                // ✅ Action Buttons (Copy, Save, Share, Favorite)
                HStack {
                    Spacer()
                    
                    // 📋 Copy Button
                    Button(action: {
                        UIPasteboard.general.string = name.name
                        showToastMessage("Text copied to clipboard")
                    }) {
                        VStack {
                            Image(systemName: "doc.on.doc")
                                .font(.title2)
                            Text("Copy").font(.caption2)
                        }
                    }

                    Spacer()

                    // 🖼 Save as Image Button (Premium)
                    Button(action: {
                        renderCardAsImage { image in
                            if let image = image {
                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                showToastMessage("Premium image saved to Photos")
                            }
                        }
                    }) {
                        VStack {
                            Image(systemName: "photo")
                                .font(.title2)
                            Text("Save").font(.caption2)
                        }
                    }

                    Spacer()

                    // share button
                    Button(action: {
                        isRendering = true // Start loading
                        renderCardAsImage { image in
                            if let image = image {
                                self.renderedImage = image
                                isRendering = false // Stop loading
                                showShareSheet = true
                            } else {
                                isRendering = false // Ensure loading stops even if image rendering fails
                            }
                        }
                    }) {
                        VStack {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                            Text("Share").font(.caption2)
                        }
                    }
                    .sheet(isPresented: $showShareSheet) {
                        if let image = renderedImage {
                            ActivityView(activityItems: [image])
                        }
                    }

                    Spacer()

                    // ❤️ Favorite Button
                    Button(action: {
                        isFavorited.toggle()
                        showToastMessage(isFavorited ? "Added to favorites" : "Removed from favorites")
                    }) {
                        VStack {
                            Image(systemName: isFavorited ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(isFavorited ? Color.purple : .white.opacity(0.9))
                            Text("Save").font(.caption2)
                        }
                    }

                    Spacer()
                }
                .foregroundColor(.white.opacity(0.9))
                .padding(.vertical, 8)
                .foregroundColor(.white.opacity(0.9))
                .padding(.vertical, 8)

                // ✅ "Check Domain Availability" Button (Secondary)
                Button(action: {
                    // Action will be added later
                }) {
                    HStack {
                        Image(systemName: "globe")
                            .font(.title3)
                        Text("Check Domain Availability")
                            .font(.body)
                            .fontWeight(.medium)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40) // ✅ Square Shape
            
            // ✅ Toast Notification
            if showToast {
                Text(toastMessage)
                    .font(.subheadline)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.opacity)
                    .animation(.easeInOut, value: showToast) // ✅ Fixed: Uses animation(_:value:)
                    .padding(.bottom, 40)
            }
        }
        .background(RenderingView(image: $renderedImage)) // ✅ For rendering image
        ZStack {
            if isRendering {
                Color.black.opacity(0.7) // Dark blur background
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)

                    Text("Preparing Image...")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
    }

    // 📢 Show Toast Function
    private func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
        }
    }

    

    // 📸 Convert View to Premium 9:16 Portrait Image
    private func renderCardAsImage(completion: @escaping (UIImage?) -> Void) {
        let imageSize = CGSize(width: 1080, height: 1920) // ✅ 9:16 Portrait
        let renderer = UIGraphicsImageRenderer(size: imageSize)

        let image = renderer.image { ctx in
            let rect = CGRect(origin: .zero, size: imageSize)
            let context = ctx.cgContext

            // 🎨 Draw Background Gradient (Black → Purple → Black)
            let gradientColors: [CGColor] = [
                UIColor.black.cgColor,
                UIColor.purple.withAlphaComponent(0.8).cgColor,
                UIColor.black.cgColor
            ]
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: gradientColors as CFArray,
                locations: [0.0, 0.5, 1.0]
            )
            context.drawLinearGradient(
                gradient!,
                start: CGPoint(x: imageSize.width / 2, y: 0),
                end: CGPoint(x: imageSize.width / 2, y: imageSize.height),
                options: []
            )

            // ❄️ Draw Frosted Glass Card (Centered)
            let cardWidth: CGFloat = imageSize.width * 0.75
            let cardHeight: CGFloat = imageSize.height * 0.22
            let cardRect = CGRect(
                x: (imageSize.width - cardWidth) / 2,
                y: (imageSize.height - cardHeight) / 2,
                width: cardWidth,
                height: cardHeight
            )

            // 🔲 Glass Card Background with **Strong Drop Shadow**
            context.setShadow(offset: CGSize(width: 10, height: 10), blur: 25, color: UIColor.black.withAlphaComponent(0.5).cgColor)
            context.setFillColor(UIColor.white.withAlphaComponent(0.15).cgColor)
            let roundedPath = UIBezierPath(roundedRect: cardRect, cornerRadius: 30)
            context.addPath(roundedPath.cgPath)
            context.fillPath()

            // ✍️ Draw Business Name (Main Highlight) - **With More Spacing**
            let nameText = NSAttributedString(
                string: name.name,
                attributes: [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.boldSystemFont(ofSize: 75),
                    .shadow: NSShadow()
                ]
            )
            let nameSize = nameText.size()
            let namePoint = CGPoint(
                x: cardRect.midX - nameSize.width / 2,
                y: cardRect.midY - nameSize.height / 2 - 40 // **Increased Spacing**
            )
            nameText.draw(at: namePoint)

            // 📝 Draw Tagline (Multi-Line & Secondary Highlight) - **More Space & Better Wrapping**
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping

            let taglineText = NSAttributedString(
                string: name.tagline,
                attributes: [
                    .foregroundColor: UIColor.white.withAlphaComponent(0.8),
                    .font: UIFont.systemFont(ofSize: 38),
                    .paragraphStyle: paragraphStyle
                ]
            )
            let taglineRect = CGRect(
                x: cardRect.origin.x + 50,
                y: cardRect.midY + 20, // **More spacing from the name**
                width: cardWidth - 100,
                height: cardHeight * 0.6
            )
            taglineText.draw(in: taglineRect)
        }

        completion(image)
    }
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
    NameCardView(name: BusinessName(name: "Nexova", tagline: "A modern, tech-forward name perfect for innovation-focused brands", tags: ["Technology", "Innovative"]))
}
