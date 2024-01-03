//
//  CharacterServiceGraphQL.swift
//  RickCombine
//
//  Created by Cincinnati Ai on 1/2/24.
//
import Apollo
import Combine
import Foundation

class CharacterServiceGraphQL {
    private let apollo: ApolloClient
    
    init() {
        let url = URL(string: "https://rickandmortyapi.com/graphql")!
        let store = ApolloStore(cache: InMemoryNormalizedCache())
        let networkTransport = RequestChainNetworkTransport(interceptorProvider: DefaultInterceptorProvider(store: store), endpointURL: url)
        self.apollo = ApolloClient(networkTransport: networkTransport, store: store)
    }
    
    func getCharacters(page: Int) -> AnyPublisher<CharacterQuery.Data, Error> {
            let query = CharacterQuery(page: page)

            return Future { promise in
                self.apollo.fetch(query: query) { result in
                    switch result {
                    case let .success(graphQLResult):
                        if let data = graphQLResult.data {
                            promise(.success(data))
                        } else if let error = graphQLResult.errors?.first {
                            promise(.failure(error))
                        } else {
                            promise(.failure(Errors.wrongFetch))
                        }
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    }
