//
//  CharactersResponse.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 19/03/2026.
//

import SwiftUI

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
    let status: Status
    let gender: Gender
    let image: String
    let origin: Origin
    let location: Location
    let episode: [String]
    
    enum Status: String, Decodable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
        
        var localized: String {
            switch self {
            case .alive: return "Żywy"
            case .dead: return "Martwy"
            case .unknown: return "Nieznany"
            }
        }
        
        var color: Color {
            switch self {
            case .alive: return .green
            case .dead: return .red
            case .unknown: return .gray
            }
        }
    }

    enum Gender: String, Decodable {
        case female = "Female"
        case male = "Male"
        case genderless = "Genderless"
        case unknown = "unknown"
        
        var localized: String {
            switch self {
            case .female: return "Kobieta"
            case .male: return "Mężczyzna"
            case .genderless: return "Bezpłciowy"
            case .unknown: return "Nieznana"
            }
        }
    }
    
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
