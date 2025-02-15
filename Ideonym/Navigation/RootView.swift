//
//  RootView.swift
//  ideonym
//
//  Created by GK Naidu on 10/02/25.
//

import Foundation
import SwiftUI

struct RootView: View {
    @StateObject private var navigationManager = NavigationManager() // Centralized navigation manager
    @StateObject private var viewModel = BusinessNameViewModel() // Shared ViewModel for the app

    var body: some View {
        ZStack {
            Group {
                switch navigationManager.appStatus {
                case .splash:
                    SplashScreen()
                        .transition(.opacity)
                case .welcome:
                    WelcomeView()
                        .transition(.move(edge: .trailing))
                case .login:
                    LoginView()
                        .transition(.slide)
                case .main:
                    ViewNavigationFlow() // Main flow of the app
                        .environmentObject(navigationManager)
                        .environmentObject(viewModel)
                }
            }
        }
        .animation(.easeInOut, value: navigationManager.appStatus) // Smooth transition animations
        .environmentObject(navigationManager) // Inject navigation manager into the environment
        .preferredColorScheme(.light) // Force light mode for the app
    }
}
