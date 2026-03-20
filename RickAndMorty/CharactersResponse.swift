//
//  CharactersResponse.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 19/03/2026.
//

struct CharactersResponse: @nonisolated Decodable {
    let info: Info
    let results: [Character]
}

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
    
    var nextPageExist: Bool {
        next != nil
    }
}

struct Character: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let status: String
    let gender: String
    let image: String
    let origin: Origin
    let location: Location
    let episode: [String]

    struct Location: Decodable, Equatable {
        let name: String
        let url: String
    }
    
    struct Origin: Decodable, Equatable {
        let name: String
        let url: String
    }

    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id
    }
}
