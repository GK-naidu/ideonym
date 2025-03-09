//
//  ShareSheetManager.swift
//  ideonym
//
//  Created by GK Naidu on 02/03/25.
//

import UIKit
import SwiftUI

class ShareSheetManager: ObservableObject {
    static let shared = ShareSheetManager() // Singleton

    @Published var isShowingShareSheet: Bool = false
    private var activityViewController: UIActivityViewController?

    func share(items: [Any]) {
        guard let topController = getTopViewController() else { return }

        DispatchQueue.main.async {
            self.activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)

            // Prevent auto-dismissal by keeping completion handler alive
            self.activityViewController?.completionWithItemsHandler = { _, _, _, _ in
                DispatchQueue.main.async {
                    self.isShowingShareSheet = false // Dismiss only when sharing completes
                }
            }

            topController.present(self.activityViewController!, animated: true, completion: nil)
            self.isShowingShareSheet = true
        }
    }

    // ✅ Updated method to get the top view controller in iOS 15+
    private func getTopViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }

        var topController = window.rootViewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
}
