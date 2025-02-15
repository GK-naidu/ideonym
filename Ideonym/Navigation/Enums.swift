//
//  Enums.swift
//  ideonym
//
//  Created by GK Naidu on 10/02/25.
//

import Foundation
import SwiftUI
enum NavigationStep: Int {
    case ideaInput = 0
    case selectCategory
    case selectTone
    case nameList

    // Button text for each step
    var buttonText: String {
        switch self {
        case .ideaInput, .selectCategory, .selectTone:
            return "Next"
        case .nameList:
            return "Finish"
        }
    }

    // Determine transition type
    var transitionType: AnyTransition {
        switch self {
        case .ideaInput, .selectCategory, .selectTone:
            return .move(edge: .trailing)
        case .nameList:
            return .move(edge: .leading)
        }
    }
}



enum AppStatus {
    case splash
    case welcome
    case login
    case main
}
