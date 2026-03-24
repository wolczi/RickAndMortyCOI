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
    struct State: Equatable , Identifiable {
        var id: Int { character.id }
        let character: Character
        var isFavorite: Bool = false
        
        @Presents var episodeDetails: EpisodeDetailsReducer.State?
    }
    
    enum Action {
        case favoriteButtonTapped
        case navigateToEpisodeDetails(Int)
        case episodeDetails(PresentationAction<EpisodeDetailsReducer.Action>)
        case delegate(Delegate)
    }
    
    @CasePathable
    enum Delegate {
        case favoriteButtonTapped
    }
    
    @Dependency(\.favoritesManager) var favoritesManager
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
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
                
                return .send(.delegate(.favoriteButtonTapped))
            case .navigateToEpisodeDetails(let id):
                state.episodeDetails = .init(episodeID: id)
                return .none
            case .episodeDetails:
                return .none
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$episodeDetails, action: \.episodeDetails) {
            EpisodeDetailsReducer()
        }
    }
}
