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

    enum CodingKeys: String, CodingKey {
        case names
        case Preferences = "Preferences" // Case-sensitive match
    }
}

struct BusinessName: Decodable, Identifiable {
    var id: UUID = UUID() // Automatically generated
    var name: String
    var tagline: String

    // Exclude `id` from decoding
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
