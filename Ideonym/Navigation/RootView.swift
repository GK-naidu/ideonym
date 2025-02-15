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
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true // ✅ Detect first-time launch

    var body: some View {
        ZStack {
            if isFirstLaunch {
                WelcomeScreensView(onFinish: {
                    isFirstLaunch = false // ✅ Mark as seen
                    navigationManager.appStatus = .main // ✅ Move to main app flow
                })
            } else {
                ViewNavigationFlow()
                    .environmentObject(navigationManager)
                    .environmentObject(viewModel)
            }
        }
        .animation(.easeInOut, value: isFirstLaunch)
        .preferredColorScheme(.light)
    }
}
