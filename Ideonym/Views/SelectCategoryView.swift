//
//  SelectCategoryView.swift
//  ideonym
//
//  Created by GK Naidu on 04/02/25.
//

import SwiftUI

struct SelectCategoryView: View {
    @ObservedObject var viewModel: BusinessNameViewModel
    let onNext: () -> Void

    var body: some View {
        SelectableListView(
            title: "Select a Category",
            options: ["Tech", "Business", "Fashion", "Health", "Gaming", "Other"],
            selectedOption: $viewModel.selectedCategory,
            onNext: onNext
        )
    }
}

