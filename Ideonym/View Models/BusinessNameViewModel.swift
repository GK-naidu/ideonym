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
    @Published var errorMessage: String?

    // Dynamically read API URL from Info.plist
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

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Network Error: \(error.localizedDescription)"
                    completion()
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received from the server."
                    completion()
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(GeneratedNameModel.self, from: data)
                    self.generatedNames = decodedResponse.names
                    completion()
                } catch {
                    self.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                    completion()
                }
            }
        }.resume()
    }
}
