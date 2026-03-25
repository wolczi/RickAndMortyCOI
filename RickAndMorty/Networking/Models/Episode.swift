//
//  EpisodeResponse.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

struct Episode: Decodable, Identifiable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode = "episode"
        case characters
    }
}
