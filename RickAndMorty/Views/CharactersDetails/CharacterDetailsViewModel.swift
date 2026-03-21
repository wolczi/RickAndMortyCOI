//
//  CharacterDetailsViewModel.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import Combine
import Foundation

@MainActor
final class CharacterDetailsViewModel: ObservableObject {
    @DIResolved private var favoritesManager: FavoritesManager
    
    let character: Character
    private var cancellables = Set<AnyCancellable>()
    
    var isFavorite: Bool {
        favoritesManager.isFavorite(character.id)
    }
    
    init(character: Character) {
        self.character = character
        
        favoritesManager.$favoriteIds
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func toggleFavorite() {
        favoritesManager.toggleFavorite(character.id)
    }
}
