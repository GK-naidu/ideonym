//
//  BusinessNameViewModel.swift
//  ideonym
//
//  Created by GK Naidu on 04/02/25.
//

import Foundation
import SwiftUI

class BusinessNameViewModel: ObservableObject {
    // 🔹 Business Name Generation Properties
    @Published var idea: String = ""
    @Published var selectedCategory: String = ""
    @Published var selectedTone: String = ""
    @Published var selectedBlends: [String] = []
    @Published var isLoading: Bool = false
    @Published var generatedNames: [BusinessName] = []
    @Published var selectedBusinessName: BusinessName?
    @Published var errorMessage: String? {
        didSet {
            showError = errorMessage != nil // Automatically updates showError
        }
    }
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var renderedImage: UIImage?
    @Published var showError: Bool = false // ✅ For displaying error messages

    // 🔹 Domain Availability Properties
    @Published var isCheckingDomain: Bool = false
    @Published var domainStatus: String? = nil

    // 🔹 Favorite Names
    @Published var isFavorited: Bool = false
    private let favoritesKey = "favoriteNames"

    // 📡 API Endpoint (from Info.plist)
    private var apiURL: URL {
        guard let urlString = Bundle.main.infoDictionary?["API_URL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("API_URL is not properly configured in Info.plist")
        }
        return url
    }

    // 🌟 Generate Business Names from API
    func generateBusinessNames(completion: @escaping () -> Void) {
        guard !idea.isEmpty, !selectedCategory.isEmpty, !selectedTone.isEmpty else {
            self.errorMessage = "Please fill all fields before generating names."
            completion()
            return
        }

        isLoading = true
        errorMessage = nil
        showError = false

        let requestBody: [String: Any] = [
            "idea": idea,
            "tone": selectedTone,
            "categories": [selectedCategory],
            "blend": selectedBlends
        ]

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])

        print("📡 Sending request to API: \(apiURL)")
        print("📩 Request Body: \(requestBody)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Network Error: \(error.localizedDescription)"
                    self.showError = true
                    print("❌ API Error: \(error.localizedDescription)")
                    completion()
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received from the server."
                    self.showError = true
                    print("❌ API Error: No data received")
                    completion()
                    return
                }

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📩 Raw JSON Response: \(jsonString)")
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(GeneratedNameModel.self, from: data)
                    self.generatedNames = decodedResponse.names
                    print("✅ Successfully decoded response: \(self.generatedNames)")
                    completion()
                } catch {
                    self.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                    self.showError = true
                    print("❌ Decoding Error: \(error.localizedDescription)")
                    completion()
                }
            }
        }.resume()
    }

    // 🌐 Check Domain Availability using WHOIS API
    func checkDomainAvailability(for name: String) {
        let domain = "\(name.lowercased().replacingOccurrences(of: " ", with: ""))" + ".com"
        let whoisAPI = "https://www.whoisxmlapi.com/whoisserver/WhoisService?apiKey=YOUR_API_KEY&domainName=\(domain)&outputFormat=json"

        isCheckingDomain = true
        domainStatus = nil

        guard let url = URL(string: whoisAPI) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isCheckingDomain = false
                if let error = error {
                    self.domainStatus = "Error ❌"
                    print("Domain check error:", error.localizedDescription)
                    return
                }
                guard let data = data,
                      let jsonString = String(data: data, encoding: .utf8) else {
                    self.domainStatus = "Unknown ❓"
                    return
                }

                self.domainStatus = jsonString.contains("available") ? "Available ✅" : "Taken ❌"
            }
        }.resume()
    }

    func saveImage(_ businessName: BusinessName) {
        renderCardAsImage(for: businessName) { image in
            if let image = image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                DispatchQueue.main.async {
                    self.alertMessage = "Image saved to Photos!"
                    self.showAlert = true
                }
            }
        }
    }

    // ✅ Copy Text Function
    func copyText(_ text: String) {
        UIPasteboard.general.string = text
        DispatchQueue.main.async {
            self.alertMessage = "Text copied to clipboard!"
            self.showAlert = true
        }
    }
    
    
    // ❤️ Toggle Favorite Name
    func toggleFavorite(name: String) {
        var favorites = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []

        if favorites.contains(name) {
            favorites.removeAll { $0 == name }
            isFavorited = false
        } else {
            favorites.append(name)
            isFavorited = true
        }

        UserDefaults.standard.setValue(favorites, forKey: favoritesKey)
    }
    // ✅ Share Image Function (Handles Async Rendering & State Updates)
    func shareImage(for name: BusinessName, completion: @escaping () -> Void) {
        renderCardAsImage(for: name) { image in
            DispatchQueue.main.async {
                if let image = image {
                    self.renderedImage = image
                    completion() // ✅ Notify the view that sharing is ready
                } else {
                    self.alertMessage = "Failed to generate image for sharing."
                    self.showAlert = true
                }
            }
        }
    }
    // ✅ Render NameCard as Image with 9:16 Aspect Ratio
    func renderCardAsImage(for name: BusinessName, completion: @escaping (UIImage?) -> Void) {
        let targetSize = CGSize(width: 1080, height: 1920) // ✅ 9:16 Aspect Ratio

        DispatchQueue.main.async {
            let view = ZStack {
                // ✅ Improved Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)

                // ✅ Enhanced NameCard
                VStack(spacing: 20) {
                    Text(name.name)
                        .font(.system(size: 80, weight: .bold)) // ✅ Larger text for better visibility
                        .foregroundColor(.white)

                    Text(name.tagline)
                        .font(.system(size: 36, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(width: targetSize.width * 0.75, height: targetSize.height * 0.35) // ✅ Adjusted size for better fit
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.25)) // ✅ Less transparency for better contrast
                        .blur(radius: 15)
                )
                .shadow(radius: 15)
            }
            .frame(width: targetSize.width, height: targetSize.height)

            let controller = UIHostingController(rootView: view)
            controller.view.frame = CGRect(origin: .zero, size: targetSize)
            controller.view.backgroundColor = UIColor.clear

            // ✅ Render as Image
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            let image = renderer.image { ctx in
                controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }

            completion(image) // ✅ Return the generated image
        }
    }
}
