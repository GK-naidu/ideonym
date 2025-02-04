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

    let apiURL = URL(string: "https://ideonymapi.vercel.app/api/generate")!

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

        // Add logging to track request
        print("Request Body: \(requestBody)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                // Handle networking errors
                if let error = error {
                    self.errorMessage = "Network Error: \(error.localizedDescription)"
                    print("Error: \(error.localizedDescription)")
                    completion()
                    return
                }

                // Check if response is valid
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    if !(200...299).contains(httpResponse.statusCode) {
                        self.errorMessage = "Server returned status code \(httpResponse.statusCode)"
                        completion()
                        return
                    }
                }

                guard let data = data else {
                    self.errorMessage = "No data received from the server."
                    print("Error: No data received")
                    completion()
                    return
                }

                // Debug raw response
                print("Raw Response: \(String(data: data, encoding: .utf8) ?? "No Response")")

                do {
                    let decodedResponse = try JSONDecoder().decode(GeneratedNameModel.self, from: data)
                    self.generatedNames = decodedResponse.names
                    print("Decoded Response: \(decodedResponse)")
                    completion()
                } catch {
                    self.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                    print("Decoding Error: \(error.localizedDescription)")
                    completion()
                }
            }
        }.resume()
    }
}
