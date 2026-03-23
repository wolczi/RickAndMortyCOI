//
//  APIClient.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 18/03/2026.
//

import SwiftUI
import ComposableArchitecture

@DependencyClient
struct APIClient {
    var fetchCharacters: (_ page: Int) async throws -> CharactersResponse
    var fetchEpisode: (_ id: Int) async throws -> Episode
}

extension APIClient: DependencyKey {
    static let liveValue: APIClient = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session = URLSession(configuration: configuration)
        
        @Sendable func request<T: Decodable>(_ route: APIRouter) async throws -> T {
            let urlRequest = try route.asURLRequest()
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
  
            return try decoder.decode(T.self, from: data)
        }
        
        return Self(
            fetchCharacters: { page in
                try await request(.getCharacters(page: page))
            },
            fetchEpisode: { id in
                try await request(.getEpisode(id: id))
            }
        )
    }()
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
