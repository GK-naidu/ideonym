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
    var body: some Scene {
        WindowGroup {
            NavigationView {
                IdeaInputView(viewModel: viewModel)
            }
        }
    }
}
