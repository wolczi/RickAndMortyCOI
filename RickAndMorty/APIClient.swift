//
//  APIClient.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 18/03/2026.
//

import Alamofire
import Foundation

protocol APIClientProtocol {
    func fetchCharacters(page: Int) async throws -> CharactersResponse
}

final class APIClient: APIClientProtocol {
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func fetchCharacters(page: Int) async throws -> CharactersResponse {
        let request = session
            .request(MovieRouter.getCharacters(page: page))
            .validate()
        
        let response = await request.serializingDecodable(CharactersResponse.self).response
        
        switch response.result {
        case .success(let characterResponse):
            return characterResponse
        case .failure(let error):
            // Tutaj możesz zmapować błąd na własny typ, np. APIError
            throw error
        }
    }
}

enum MovieRouter: URLRequestConvertible {
    case getCharacters(page: Int)

    var baseURL: URL {
        return URL(string: "https://rickandmortyapi.com/api")!
    }

    var path: String {
        switch self {
        case .getCharacters: return "/character"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getCharacters(let page):
            return ["page": page]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCharacters: return .get
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
