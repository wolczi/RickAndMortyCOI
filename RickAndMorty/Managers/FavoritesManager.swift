//
//  FavoritesManager.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI
import Combine

final class FavoritesManager: ObservableObject {
    @AppStorage("favorite_ids") private var favoriteIdsData: Data = Data()
    
    @Published private(set) var favoriteIds: Set<Int> = []
    
    init() {
        self.favoriteIds = decode()
    }
    
    func isFavorite(_ id: Int) -> Bool {
        favoriteIds.contains(id)
    }
    
    func toggleFavorite(_ id: Int) {
        if favoriteIds.contains(id) {
            favoriteIds.remove(id)
        } else {
            favoriteIds.insert(id)
        }
        save()
    }
    
    private func decode() -> Set<Int> {
        (try? JSONDecoder().decode(Set<Int>.self, from: favoriteIdsData)) ?? []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(favoriteIds) {
            favoriteIdsData = encoded
        }
    }
}
