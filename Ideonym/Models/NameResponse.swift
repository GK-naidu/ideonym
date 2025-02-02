//
//  NameResponse.swift
//  ideonym
//
//  Created by GK Naidu on 02/02/25.
//

import Foundation

// MARK: - Main Response Model
struct NameResponse: Codable {
    let names: [BusinessName]
}

// MARK: - Business Name Model
struct BusinessName: Codable, Identifiable {
    var id = UUID()
    let name: String
    let availability: Availability
}

// MARK: - Availability Model
struct Availability: Codable {
    let socialMedia: SocialMediaAvailability
}

// MARK: - Social Media Availability Model
struct SocialMediaAvailability: Codable {
    let twitter: Bool
    let youtube: Bool
    let instagram: Bool
}
