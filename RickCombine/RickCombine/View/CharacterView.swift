//
//  CharacterView.swift
//  RickCombine
//
//  Created by Cincinnati Ai on 12/21/23.
//

import SwiftUI

struct CharacterView: View {
    
    @ObservedObject var viewModel: CharacterViewModel
    
    init(viewModel: CharacterViewModel = CharacterViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Character")
                .foregroundStyle(.blue)
            Spacer()
            buildScreen()
            Spacer()
        }
        .onAppear {
            viewModel.onViewReady()
        }
        .padding()
    }
    
    @ViewBuilder
    private func buildScreen() -> some View {
        switch viewModel.state {
        case .none:
            EmptyView()
        case .loading:
            ProgressView()
        case .success(let characters):
            buildDisplayable(with: characters)
        case .error(let message):
            Text(message)
        }
    }
    
    private func buildDisplayable(with characters: [DisplayableCharacter]) -> some View {
        List(characters, id: \.name) { character in
            VStack {
                Text(character.name)
                    .onAppear(perform: {
                        viewModel.onCharacterShown(character)
                    })
                    .onTapGesture {
                        viewModel.didCharacterSelect(character)
                    }
            }
        } .refreshable {
            viewModel.onViewReady()
        }
    }
}

#Preview {
    CharacterView()
}
