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
            AnimatedMeshGradient()
                .ignoresSafeArea()

            if viewModel.isLoading {
                GeneratingProgressView()
                    .transition(.opacity)
                    .zIndex(2) // ✅ Keeps progress view on top
            } else {
                currentStepView()
                    .transition(navigationManager.moveForward ? .move(edge: .trailing) : .move(edge: .leading))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: navigationManager.currentStep)
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
        .overlay(alignment: .bottom) {
            if shouldShowNextButton() {
                navigationControlButton()
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
            SelectToneView(viewModel: viewModel, onNext: { startGeneratingNames() })
        case .nameList:
            NameListView(viewModel: viewModel)
        case .nameInfo:
            if let selectedName = viewModel.selectedBusinessName { // ✅ Get selected name
                NameInfoView(name: selectedName)
            } else {
                Text("Error: No Name Selected") // ✅ Handle missing name gracefully
                    .foregroundColor(.red)
            }
        }
    }

    // MARK: - Start Generating Names (Fix)
    private func startGeneratingNames() {
        print("🚀 Generating names started...") // ✅ Debug log
        DispatchQueue.main.async {
            viewModel.isLoading = true // ✅ Show progress view immediately

            viewModel.generateBusinessNames {
                DispatchQueue.main.async {
                    viewModel.isLoading = false // ✅ Hide progress view once done
                    if !viewModel.generatedNames.isEmpty {
                        print("✅ Names generated, moving to NameListView") // ✅ Debug log
                        navigationManager.navigateToStep(.nameList)
                    } else {
                        print("❌ No names were generated") // ✅ Debug log
                    }
                }
            }
        }
    }

    // MARK: - Move to Next Step (No Change)
    private func moveToNextStep() {
        DispatchQueue.main.async {
            switch navigationManager.currentStep {
            case .ideaInput:
                navigationManager.navigateToStep(.selectCategory)
            case .selectCategory:
                navigationManager.navigateToStep(.selectTone)
            default:
                break
            }
        }
    }

    // MARK: - Next Button (Unified)
    private func navigationControlButton() -> some View {
        Button(action: {
            if navigationManager.currentStep == .selectTone {
                startGeneratingNames()
            } else {
                moveToNextStep()
            }
        }) {
            Text("Next")
                .frame(maxWidth: 300)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .foregroundColor(.black)
        }
        .padding(.bottom, 20)
    }

    // MARK: - Button Visibility Helpers
    private func shouldShowNextButton() -> Bool {
        return !viewModel.isLoading && ( // ✅ Hides button when isLoading is true
            navigationManager.currentStep == .ideaInput ||
            navigationManager.currentStep == .selectCategory ||
            navigationManager.currentStep == .selectTone
           
        )
    }

    private func shouldShowBackButton() -> Bool {
        return !viewModel.isLoading && (navigationManager.currentStep == .selectCategory || navigationManager.currentStep == .selectTone ||  navigationManager.currentStep == .nameInfo)
    }

    private func shouldShowCloseButton() -> Bool {
        return !viewModel.isLoading && navigationManager.currentStep == .nameList
    }

    private func floatingBackButton() -> some View {
        Button(action: { navigationManager.goBack() }) {
            Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundColor(.white)
                .padding(12)
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
        }
        .frame(width: 50, height: 50)
        .padding(.leading, 16)
        .padding(.top, 16)
    }

    private func floatingCloseButton() -> some View {
        Button(action: {
            print("❌ Closing Name List and Resetting Navigation")
            navigationManager.reset()
        }) {
            Image(systemName: "xmark")
                .font(.title2)
                .foregroundColor(.white)
                .padding(12)
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
        }
        .frame(width: 50, height: 50)
        .padding(.trailing, 16)
        .padding(.top, 16)
    }
}
