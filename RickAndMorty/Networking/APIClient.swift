//
//  APIClient.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 18/03/2026.
//

import Alamofire
import Foundation
import SwiftUI

protocol APIClientProtocol {
    func fetchCharacters(page: Int) async throws -> CharactersResponse
    func fetchEpisode(id: Int) async throws -> Episode
}

final class APIClient: APIClientProtocol {
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        
        return Session(configuration: configuration)
    }()
    
    private func request<T: Decodable>(_ route: MovieRouter) async throws -> T {
        try await session
            .request(route)
            .validate()
            .serializingDecodable(T.self)
            .value
    }
    
    func fetchCharacters(page: Int) async throws -> CharactersResponse {
        try await request(.getCharacters(page: page))
    }
    
    func fetchEpisode(id: Int) async throws -> Episode {
        try await request(.getEpisode(id: id))
    }
}

enum MovieRouter: URLRequestConvertible {
    case getCharacters(page: Int)
    case getEpisode(id: Int)

    var baseURL: URL {
        return URL(string: "https://rickandmortyapi.com/api")!
    }

    var path: String {
        switch self {
        case .getCharacters: return "/character"
        case .getEpisode(let id): return "/episode/\(id)"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getCharacters(let page):
            return ["page": page]
        case .getEpisode:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCharacters: return .get
        case .getEpisode: return .get
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}

private struct APIClientKey: EnvironmentKey {
    static let defaultValue: APIClientProtocol = APIClient()
}

extension EnvironmentValues {
    var apiClient: APIClientProtocol {
        get { self[APIClientKey.self] }
        set { self[APIClientKey.self] = newValue }
    }
}
