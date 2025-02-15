//
//  NavigationManager.swift
//  ideonym
//
//  Created by GK Naidu on 10/02/25.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var appStatus: AppStatus = .main
    @Published var navigationPath: [NavigationStep] = []
    @Published var currentStep: NavigationStep = .ideaInput

    // Determines when to show back button
    var shouldShowBackButton: Bool {
        return !navigationPath.isEmpty && currentStep != .ideaInput
    }

    var shouldShowCloseButton: Bool {
        return currentStep == .nameList
    }

    // Track last step for transition logic
    private var previousStep: NavigationStep = .ideaInput

    // Determine transition direction
    var moveForward: Bool {
        return navigationPath.last?.rawValue ?? 0 > previousStep.rawValue
    }

    // Navigate to a new step
    func navigateToStep(_ step: NavigationStep) {
        guard step != currentStep else { return } // Prevent duplicate navigation
        previousStep = currentStep
        navigationPath.append(step)
        withAnimation(.easeInOut) {
            currentStep = step
        }
    }

    // Go back to previous step
    func goBack() {
        guard !navigationPath.isEmpty else {
            currentStep = .ideaInput
            return
        }
        previousStep = currentStep
        navigationPath.removeLast()
        withAnimation(.easeInOut) {
            currentStep = navigationPath.last ?? .ideaInput
        }
    }

    // Reset Navigation (After Finishing Flow)
    func reset() {
        navigationPath.removeAll()
        currentStep = .ideaInput
    }

    // Return to Home
    func goToHome() {
        appStatus = .main
        reset()
    }
}
