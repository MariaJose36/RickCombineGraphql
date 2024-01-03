//
//  RickCombineApp.swift
//  RickCombine
//
//  Created by Cincinnati Ai on 12/21/23.
//

import SwiftUI

@main
struct RickCombineApp: App {
    var body: some Scene {
        WindowGroup {
            AppCoordinator(navManager: AppNavigationDelegate())
        }
    }
}
