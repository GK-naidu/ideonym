//
//  ViewNavigationFlow.swift
//  ideonym
//
//  Created by GK Naidu on 10/02/25.
//


import SwiftUI

struct ViewNavigationFlow: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel = BusinessNameViewModel()

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .purple], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            if viewModel.isLoading {
                GeneratingProgressView()
                    .transition(.opacity)
                    .zIndex(2) // ✅ Ensures progress view is fully on top
            } else {
                currentStepView()
                    .transition(navigationManager.moveForward ? .move(edge: .trailing) : .move(edge: .leading))
                    .zIndex(1) // ✅ Keeps content below progress view
            }
        }
        .animation(.easeInOut, value: navigationManager.currentStep)
        
        // ✅ Floating Navigation Controls (Using `.frame(alignment:)`)
        .overlay(alignment: .topLeading) {
            if shouldShowBackButton() {
                floatingBackButton()
            }
        }
        .overlay(alignment: .topTrailing) {
            if shouldShowCloseButton() {
                floatingCloseButton()
            }
        }
    }

    // MARK: - Current Step View
    @ViewBuilder
    private func currentStepView() -> some View {
        switch navigationManager.currentStep {
        case .ideaInput:
            IdeaInputView(viewModel: viewModel, onNext: { moveToNextStep() })
        case .selectCategory:
            SelectCategoryView(viewModel: viewModel, onNext: { moveToNextStep() })
        case .selectTone:
            SelectToneView(viewModel: viewModel, onGenerate: {
                viewModel.isLoading = true
                viewModel.generateBusinessNames {
                    DispatchQueue.main.async {
                        viewModel.isLoading = false
                        moveToNextStep()
                    }
                }
            })
        case .nameList:
            NameListView(viewModel: viewModel)
       
        }
    }

    // MARK: - Move to Next Step
    private func moveToNextStep() {
        DispatchQueue.main.async {
            switch navigationManager.currentStep {
            case .ideaInput:
                navigationManager.navigateToStep(.selectCategory)
            case .selectCategory:
                navigationManager.navigateToStep(.selectTone)
            case .selectTone:
                navigationManager.navigateToStep(.nameList)
            default:
                break
            }
        }
    }

    // MARK: - Floating Buttons
    private func floatingBackButton() -> some View {
        Button(action: { navigationManager.goBack() }) {
            Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundColor(.white)
                .padding(12)
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
        }
        .frame(width: 50, height: 50, alignment: .leading) // ✅ Positioned correctly
        .padding(.leading, 16)
        .padding(.top, 16)
    }

    private func floatingCloseButton() -> some View {
        Button(action: {
            print("❌ Closing Name List and Resetting Navigation") // ✅ Debug Log
            navigationManager.reset() // ✅ Only reset when explicitly closing
        }) {
            Image(systemName: "xmark")
                .font(.title2)
                .foregroundColor(.white)
                .padding(12)
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
        }
        .frame(width: 50, height: 50, alignment: .trailing)
        .padding(.trailing, 16)
        .padding(.top, 16)
    }

    // MARK: - Button Visibility Helpers
    private func shouldShowBackButton() -> Bool {
        return !viewModel.isLoading && (navigationManager.currentStep == .selectCategory || navigationManager.currentStep == .selectTone)
    }

    private func shouldShowCloseButton() -> Bool {
        return !viewModel.isLoading && navigationManager.currentStep == .nameList
    }
}
