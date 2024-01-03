//
//  AppCoordinator.swift
//  RickCombine
//
//  Created by Cincinnati Ai on 12/21/23.
//

import SwiftUI

struct AppCoordinator: View {
    
    @ObservedObject
    private var navManager: AppNavigationDelegate
    private var rootViewModel: CharacterViewModel
    
    init(navManager: AppNavigationDelegate = AppNavigationDelegate()) {
        self.navManager = navManager
        self.rootViewModel = CharacterViewModel(navDelegate: navManager)
    }
    var body: some View {
        NavigationStack(path: $navManager.path) {
            CharacterView(viewModel: rootViewModel)
                .navigationDestination(for: Destinations.self) {
                    destination in
                    switch destination {
                    case .selectCharacter(let select): DetailsView(viewModel: DetailsViewModel(character: select))
                    }
                }
        }
    }
}

#Preview {
    AppCoordinator()
}
