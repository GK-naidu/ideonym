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
            options: [
                "Tech",
                "Business",
                "Fashion",
                "Health",
                "Gaming",
                "Education",
                "Finance",
                "Social Impact",
                "Agriculture and Forestry",
                "Mining and Quarrying",
                "Manufacturing",
                "Construction",
                "Utilities",
                "Wholesale and Retail",
                "Transportation and Storage",
                "Food & Beverage",
                "Automotive",
                "Entertainment",
                "Publishing",
                "Telecommunications",
                "Investment",
                "Real Estate",
                "Marketing & Advertising",
                "Legal Services",
                "Security Services",
                "Government Services",
                "Non-Profit",
                "Fitness & Sports",
                "Hospitality & Travel",
                "Pets & Animals",
                "Arts & Crafts",
                "Science & Research"
            ],  icons: Array(repeating: "", count: 32),
            selectedOption: $viewModel.selectedCategory,
            onNext: {}
        )
    }
}

#Preview {
    SelectCategoryView(viewModel: BusinessNameViewModel(), onNext: {})
}
