//
//  CharacterViewModel.swift
//  RickCombine
//
//  Created by Cincinnati Ai on 12/21/23.
//
import Combine
import Foundation

class CharacterViewModel: ObservableObject {
    
    var service: CharacterServiceGraphQL
    @Published var state: CharacterState = .none
    var subscriptions: [AnyCancellable] = []
    private var page: Int = 1
    private var totalPages: Int = 0
    private var isLoading: Bool = false
    private var canKeepLoading = true
    private var displayableCharacter = [DisplayableCharacter]()
    
    private var navDelegate: DetaillsNavigationDelegate?
    
    init(service: CharacterServiceGraphQL = CharacterServiceGraphQL(), navDelegate: DetaillsNavigationDelegate? = nil, isLoading: Bool = false, canKeepLoading: Bool = true) {
        self.service = service
        self.navDelegate = navDelegate
        self.isLoading = isLoading
        self.canKeepLoading = canKeepLoading
    }
    
    func onCharacterShown(_ character: DisplayableCharacter) {
        let isLastItem = character == displayableCharacter.last
        
        if isLastItem {
            fetchResults()
        }
    }
    
    func onViewReady() {
        DispatchQueue.main.async { self.state = .loading }
        page = 1
        fetchResults()
    }
    
    func fetchResults() {
        guard canKeepLoading && !isLoading else { return }
        isLoading = true
        service.getCharacters(page: page)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self.state = .error("Oops something went wrong")
                }
            } receiveValue: { graphQLResult in
                if let results = graphQLResult.characters?.results {
                    self.isLoading = false
                    let displayableCharacters = self.mapToDisplayable(results)
                    self.displayableCharacter.append(contentsOf: displayableCharacters)
                    DispatchQueue.main.async { self.state = .success(self.displayableCharacter) }
                    
                    if results.isEmpty {
                        self.canKeepLoading = false
                    } else {
                        self.page += 1
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    private func mapToDisplayable(_ characters: [CharacterQuery.Data.Character.Result?]) -> [DisplayableCharacter] {
        return characters.compactMap { character in
            guard let name = character?.name else {
                return nil
            }
            return DisplayableCharacter(name: name)
        }
    }
    
    func didCharacterSelect(_ select: DisplayableCharacter) {
        navDelegate?.didCharacterSelect(select)
    }
}

enum CharacterState {
    case none
    case loading
    case success([DisplayableCharacter])
    case error(String)
}
