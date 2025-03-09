//
//  SelectToneView.swift
//  ideonym
//
//  Created by GK Naidu on 04/02/25.
//
import SwiftUI

struct SelectToneView: View {
    @ObservedObject var viewModel: BusinessNameViewModel
    let onNext: () -> Void
    var body: some View {
        SelectableListView(
            title: "Select a Tone",
            options: [
                       "Professional",
                       "Friendly",
                       "Innovative",
                       "Premium",
                       "Bold",
                       "Inspirational",
                       "Minimalist",
                       "Playful",
                       "Authoritative",
                       "Conversational",
                       "Empathetic",
                       "Humorous",
                       "Nostalgic",
                       "Sarcastic",
                       "Serious",
                       "Sophisticated",
                       "Urgent",
                       "Witty",
                       "Youthful"
                   ],
                   icons: Array(repeating: "", count: 19),
            selectedOption: $viewModel.selectedTone,
            onNext: {}
        )
    }
}

#Preview {
    SelectToneView(viewModel: BusinessNameViewModel(), onNext: {})
}

