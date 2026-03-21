//
//  DI.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import Foundation
import Swinject

enum DI {
    static let container: Container = .init()
    
    static let synchronizedResolver: Resolver = container.synchronize()
    
    static func registerAll() {
        container.register(APIClientProtocol.self) { _ in
            APIClient()
        }.inObjectScope(.container)
        
        container.register(FavoritesManager.self) { _ in
            FavoritesManager()
        }.inObjectScope(.container)
    }
}
