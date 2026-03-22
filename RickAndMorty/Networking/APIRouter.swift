//
//  TvShowRouter.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 22/03/2026.
//

import Foundation

enum APIRouter {
    case getCharacters(page: Int)
    case getEpisode(id: Int)

    private var baseURL: String { "https://rickandmortyapi.com/api" }

    private var path: String {
        switch self {
        case .getCharacters: return "/character"
        case .getEpisode(let id): return "/episode/\(id)"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        case .getCharacters(let page):
            return [.init(name: "page", value: "\(page)")]
        case .getEpisode:
            return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
}
