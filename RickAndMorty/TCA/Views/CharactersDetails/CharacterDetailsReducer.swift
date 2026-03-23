//
//  CharacterDetailsReducer.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 23/03/2026.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct CharacterDetailsReducer {
    @ObservableState
    struct State: Equatable {
        let character: Character
        var isFavorite: Bool = false
    }
    
    enum Action {
        case favoriteButtonTapped
    }
    
    @Dependency(\.favoritesManager) var favoritesManager
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {            
        case .favoriteButtonTapped:
            state.isFavorite.toggle()
            
            var currentFavorites = favoritesManager.loadIds()
            if state.isFavorite {
                currentFavorites.insert(state.character.id)
            } else {
                currentFavorites.remove(state.character.id)
            }
            favoritesManager.saveIds(currentFavorites)
            
            return .none
        }
    }
}
