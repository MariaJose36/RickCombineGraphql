//
//  CharacterResponse.swift
//  RickCombine
//
//  Created by Cincinnati Ai on 12/21/23.
//

import Foundation

import Foundation

struct CharacterResponse: Codable {
    let info: Info
    let character: [Character]?
    
    enum CodingKeys: String, CodingKey {
        case character = "results"
        case info = "info"
    }
}

struct Info: Codable {
    let pages: Int?
    let next: String?
    let previous: String?

    enum CodingKeys: String, CodingKey {
        case pages
        case next
        case previous = "prev"
    }
}

struct Character: Codable {
    let name: String?
    let species: String?
    let status: String?
    let gender: String?
}
