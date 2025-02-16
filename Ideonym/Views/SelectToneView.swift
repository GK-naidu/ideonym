//
//  SelectToneView.swift
//  ideonym
//
//  Created by GK Naidu on 04/02/25.
//
import SwiftUI

struct SelectToneView: View {
    @ObservedObject var viewModel: BusinessNameViewModel
    let onGenerate: () -> Void

    var body: some View {
        SelectableListView(
            title: "Select a Tone",
            options: ["Professional", "Friendly", "Innovative", "Luxury", "Other"],
            selectedOption: $viewModel.selectedTone,
            onNext: onGenerate
        )
    }
}


