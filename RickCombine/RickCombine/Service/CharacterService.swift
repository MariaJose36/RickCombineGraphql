//
//  RickService.swift
//  RickCombine
//
//  Created by Cincinnati Ai on 12/21/23.
//
import Combine
import Foundation

protocol CharacterServiceContract {
    func fetchCharacter(page: Int) -> AnyPublisher<CharacterResponse, Error>
}

class CharacterService: CharacterServiceContract {
    
    private var session: URLSession
    private var decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared, decoder: JSONDecoder =  JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchCharacter(page: Int) -> AnyPublisher<CharacterResponse, Error> {
        var components = URLComponents(string: "https://rickandmortyapi.com/api/character")
        components?.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        
        guard let url = components?.url else {
            return Fail(outputType: CharacterResponse.self, failure: Errors.invalidURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CharacterResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

enum Errors: Error {
    case invalidURL
    case wrongFetch
    case noDetails
}
