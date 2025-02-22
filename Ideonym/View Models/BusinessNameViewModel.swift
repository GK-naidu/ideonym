//
//  BusinessNameViewModel.swift
//  ideonym
//
//  Created by GK Naidu on 04/02/25.
//

import Foundation

class BusinessNameViewModel: ObservableObject {
    @Published var idea: String = ""
    @Published var selectedCategory: String = ""
    @Published var selectedTone: String = ""
    @Published var selectedBlends: [String] = []
    @Published var isLoading: Bool = false
    @Published var generatedNames: [BusinessName] = []
    @Published var errorMessage: String? {
        didSet {
            showError = errorMessage != nil // Automatically updates showError
        }
    }
    @Published var showError: Bool = false // ✅ New property for alert handling

    private var apiURL: URL {
        guard let urlString = Bundle.main.infoDictionary?["API_URL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("API_URL is not properly configured in Info.plist")
        }
        return url
    }

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

        print("📡 Sending request to API: \(apiURL)") // ✅ Debug log
        print("📩 Request Body: \(requestBody)") // ✅ Debug log

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false // ✅ Ensure loading is disabled after fetching

                if let error = error {
                    self.errorMessage = "Network Error: \(error.localizedDescription)"
                    self.showError = true
                    print("❌ API Error: \(error.localizedDescription)") // ✅ Debug log
                    completion()
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received from the server."
                    self.showError = true
                    print("❌ API Error: No data received") // ✅ Debug log
                    completion()
                    return
                }

                // ✅ Debug: Print the full JSON response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📩 Raw JSON Response: \(jsonString)")
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(GeneratedNameModel.self, from: data)
                    self.generatedNames = decodedResponse.names
                    print("✅ Successfully decoded response: \(self.generatedNames)") // ✅ Debug log
                    completion()
                } catch {
                    self.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                    self.showError = true
                    print("❌ Decoding Error: \(error.localizedDescription)") // ✅ Debug log
                    completion()
                }
            }
        }.resume()
    }
}
