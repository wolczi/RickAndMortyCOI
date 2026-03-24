//
//  FavoritesManager.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 23/03/2026.
//

import Dependencies
import Foundation

struct FavoritesManager {
    var loadIds: @Sendable () -> Set<Int>
    var saveIds: @Sendable (Set<Int>) -> Void
}

extension FavoritesManager: DependencyKey {
    static let liveValue: Self = {
        let userDefaults = UserDefaults.standard
        let key = "favorites_key"
        
        return Self(
            loadIds: {
                Set(userDefaults.array(forKey: key) as? [Int] ?? [])
            },
            saveIds: { ids in
                userDefaults.set(Array(ids), forKey: key)
            }
        )
    }()
}

extension DependencyValues {
    var favoritesManager: FavoritesManager {
        get { self[FavoritesManager.self] }
        set { self[FavoritesManager.self] = newValue }
    }
}
