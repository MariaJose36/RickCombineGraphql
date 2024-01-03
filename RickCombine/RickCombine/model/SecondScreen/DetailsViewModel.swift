//
//  DetailsViewModel.swift
//  RickCombine
//
//  Created by Cincinnati Ai on 12/21/23.
//
import Combine
import Foundation

class DetailsViewModel: ObservableObject {
    
    var service: CharacterServiceContract
    var character: DisplayableCharacter?
    @Published var state: DetailsState = .none
    private var page: Int = 1
    var subscriptions: [AnyCancellable] = []
    
    init(service: CharacterServiceContract = CharacterService(), character: DisplayableCharacter? = nil) {
        self.service = service
    }
    
    func onViewReady() {
        service.fetchCharacter(page: page)
            .flatMap { details in
                self.mapToDisplayableDetails(details.character?.first) }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure: self.state = .error("Oops something went wrong")
                }
            } receiveValue: { displayableDetails in
                self.state = .success(displayableDetails)
            }
            .store(in: &subscriptions)
    }
    
    private func mapToDisplayableDetails(_ details: Character?) -> AnyPublisher<DisplayableDetails, Error> {
        guard let details = details else {
            return Fail(error: Errors.noDetails).eraseToAnyPublisher()
        }
        let displayableDetails = DisplayableDetails(species: details.species ?? "", status: details.status ?? "", gender: details.gender ?? "")
        return Just(displayableDetails).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

enum DetailsState {
    case none
    case loading
    case success(DisplayableDetails)
    case error(String)
}
