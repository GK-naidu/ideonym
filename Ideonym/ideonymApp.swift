//
//  ideonymApp.swift
//  ideonym
//
//  Created by GK Naidu on 02/02/25.
//

import SwiftUI

@main
struct ideonymApp: App {
    @StateObject var viewModel = BusinessNameViewModel()
    @StateObject private var navigationManager = NavigationManager()
    
    init() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.setBackIndicatorImage(UIImage(), transitionMaskImage: UIImage()) // Remove back button icon
        appearance.backButtonAppearance = UIBarButtonItemAppearance(style: .plain) // Customize back button
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear] // Hide title text
        
        // Apply the appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
                    .environmentObject(navigationManager)
            }
        }
    }
}
