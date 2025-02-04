//
//  NameInputModel.swift
//  ideonym
//
//  Created by GK Naidu on 04/02/25.
//

import Foundation

/// Represents user input for generating a business name.
struct NameInputModel {
    var idea: String                 // The main business idea
    var category: String             // Selected category (e.g., Tech, Fashion, Health)
    var tone: String                 // Desired tone (e.g., Professional, Friendly)
    var blend: [String]              // Elements to blend into the name (e.g., Japanese, Space)
}
