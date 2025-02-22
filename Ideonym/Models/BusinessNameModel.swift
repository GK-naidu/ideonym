//
//  BusinessNameModel.swift
//  ideonym
//
//  Created by GK Naidu on 04/02/25.
//

import Foundation

/// Represents the full response from Gemini API.
struct GeneratedNameModel: Decodable {
    var names: [BusinessName]
    var Preferences: [Preference]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.names = try container.decode([BusinessName].self, forKey: .names)
        self.Preferences = try container.decodeIfPresent([Preference].self, forKey: .Preferences) ?? []

        if let firstPreference = self.Preferences.first {
            let category = firstPreference.category
            let tone = firstPreference.Tone

            for i in 0..<self.names.count {
                // ✅ Assign only Category & Tone as tags
                self.names[i].tags = [category, tone]
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case names
        case Preferences = "Preferences"
    }
}

struct BusinessName: Decodable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var tagline: String
    var tags: [String]?

    // ✅ Ensures tags always have a value (Prevents nil errors)
    var safeTags: [String] {
        return tags ?? ["General", "Creative"]
    }

    private enum CodingKeys: String, CodingKey {
        case name, tagline
    }
}

struct Preference: Decodable {
    var category: String
    var Tone: String
    var blendedNames: [String]

    // Map "Blended Name" with a space
    enum CodingKeys: String, CodingKey {
        case category
        case Tone
        case blendedNames = "Blended Name"
    }
}

/// Represents the user-selected preferences that influenced the AI's response.
struct Preferences: Decodable {
    var category: String
    var tone: String
    var blendedName: [String] // List of names influenced by blends (e.g., Japanese, Space)
}
