//
//  DetailsView.swift
//  RickCombine
//
//  Created by Cincinnati Ai on 12/21/23.
//

import SwiftUI

struct DetailsView: View {
    
    @ObservedObject var viewModel: DetailsViewModel
    
    init(viewModel: DetailsViewModel = DetailsViewModel()) {
        self.viewModel = viewModel
    }
    var body: some View {
        VStack {
            Text("Details")
                .foregroundStyle(.blue)
            Spacer()
            buildDetailsScreen()
            Spacer()
        } .onAppear {
            viewModel.onViewReady()
        }
    }
    
    @ViewBuilder
    private func buildDetailsScreen() -> some View {
        switch viewModel.state {
        case .none:
            EmptyView()
        case .loading:
            ProgressView()
        case .success(let details):
            buildDisplayableDetails(with: details)
        case .error(let message):
            Text(message)
        }
    }
    
    private func buildDisplayableDetails(with details: DisplayableDetails) -> some View {
        VStack {
            Text(details.species)
            Text(details.status)
            Text(details.gender)
        }
    }
}

#Preview {
    DetailsView()
}
