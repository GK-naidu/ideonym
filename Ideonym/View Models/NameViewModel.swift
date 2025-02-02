//
//  NameViewModel.swift
//  ideonym
//
//  Created by GK Naidu on 02/02/25.
//

import Foundation

@MainActor
class NameViewModel: ObservableObject {
    @Published var businessNames: [BusinessName] = []
    @Published var isLoading: Bool = false
    
    // Simulated API Call (Replace with actual network request)
    func fetchBusinessNames() async {
        isLoading = true
        
        // Simulated JSON Response (Replace with real API call)
        let jsonString = """
        {
          "names": [
            {
              "name": "Zyron",
              "availability": {
                "socialMedia": {
                  "twitter": true,
                  "youtube": false,
                  "instagram": true
                }
              }
            },
            {
              "name": "Velto",
              "availability": {
                "socialMedia": {
                  "twitter": false,
                  "youtube": false,
                  "instagram": false
                }
              }
            }
          ]
        }
        """
        
        do {
            let data = jsonString.data(using: .utf8)!
            let decodedResponse = try JSONDecoder().decode(NameResponse.self, from: data)
            self.businessNames = decodedResponse.names
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        isLoading = false
    }
}
