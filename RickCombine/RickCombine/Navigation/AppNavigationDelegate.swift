//
//  AppNavigationDelegate.swift
//  RickCombine
//
//  Created by Cincinnati Ai on 12/21/23.
//

import Foundation

class AppNavigationDelegate: ObservableObject {
    
    @Published var path: [Destinations] = []
    
    private func push(destinations: Destinations) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.path.append(destinations)
        }
    }
}

extension AppNavigationDelegate: DetaillsNavigationDelegate {
    func didCharacterSelect(_ select: DisplayableCharacter) {
        push(destinations: .selectCharacter(select))
    }
    
    
}
