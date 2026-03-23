//
//  FavoritesManager.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 23/03/2026.
//

import Dependencies
import SwiftUI

struct FavoritesManager {
    var loadIds: @Sendable () -> Set<Int>
    var saveIds: @Sendable (Set<Int>) -> Void
}

extension FavoritesManager: DependencyKey {
    static let liveValue = Self(
        loadIds: {
            let data = UserDefaults.standard.data(forKey: "favorites_key") ?? Data()
            return (try? JSONDecoder().decode(Set<Int>.self, from: data)) ?? []
        },
        saveIds: { ids in
            let data = try? JSONEncoder().encode(ids)
            UserDefaults.standard.set(data, forKey: "favorites_key")
        }
    )
}

extension DependencyValues {
    var favoritesManager: FavoritesManager {
        get { self[FavoritesManager.self] }
        set { self[FavoritesManager.self] = newValue }
    }
}
