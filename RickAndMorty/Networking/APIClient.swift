//
//  APIClient.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 18/03/2026.
//

import Foundation
import SwiftUI
import Dependencies

protocol APIClientProtocol {
    func fetchCharacters(page: Int) async throws -> CharactersResponse
    func fetchEpisode(id: Int) async throws -> Episode
}

final class APIClient: APIClientProtocol {
    private let session: URLSession = .shared
        
        private func request<T: Decodable>(_ route: APIRouter) async throws -> T {
            let urlRequest = try route.asURLRequest()
            
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        }
        
        func fetchCharacters(page: Int) async throws -> CharactersResponse {
            try await request(.getCharacters(page: page))
        }
        
        func fetchEpisode(id: Int) async throws -> Episode {
            try await request(.getEpisode(id: id))
        }
}

enum APIClientKey: DependencyKey {
    static let liveValue: APIClientProtocol = APIClient()
}

extension DependencyValues {
    var apiClient: APIClientProtocol {
        get { self[APIClientKey.self] }
        set { self[APIClientKey.self] = newValue }
    }
}
