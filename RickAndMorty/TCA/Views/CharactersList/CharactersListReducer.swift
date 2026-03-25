//
//  CharactersListReducer.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct CharactersListReducer {
    @ObservableState
    struct State: Equatable {
        enum ViewState: Equatable {
            case initial
            case loading
            case empty
            case list([Character])
            case error
        }
        
        var viewState: ViewState = .initial
        var allCharacters: [Character] = []
        var favoriteIds: Set<Int> = []
        
        var pageId = 1
        var hasMorePages = true
        
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case startInitialLoad
        case loadNextPage
        case fetchResponse(TaskResult<CharactersResponse>)
        case retryFetchData
        case showAlert
        case navigateToDetails(Character, Bool)
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Reducer(state: .equatable)
    enum Destination {
        case characterDetails(CharacterDetailsReducer)
        case alert(AlertState<Alert>)
        
        enum Alert {
            case retryFetchButtonTapped
        }
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.favoritesManager) var favoritesManager
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .startInitialLoad:
                state.viewState = .loading
          
                return fetchCharactersEffect(pageId: state.pageId)
                
            case .loadNextPage:
                return fetchCharactersEffect(pageId: state.pageId)
                
            case let .fetchResponse(.success(response)):
                state.allCharacters.append(contentsOf: response.results)
                state.hasMorePages = response.info.nextPageExist
                
                if state.pageId == 1 {
                    state.viewState = state.allCharacters.isEmpty ? .empty : .list(state.allCharacters)
                } else {
                    state.viewState = .list(state.allCharacters)
                }
                
                state.pageId += 1
                return .none
                
            case .fetchResponse(.failure):
                state.hasMorePages = false
                
                if state.allCharacters.isEmpty {
                    state.viewState = .error
                    return .none
                } else {
                    return .send(.showAlert)
                }
                
            case .retryFetchData:
                if state.allCharacters.isEmpty {
                    state.viewState = .loading
                }
                return .send(.loadNextPage)
                
            case .showAlert:
                state.destination = .alert(
                    AlertState(
                        title: { TextState("Błąd") },
                        actions: {
                            ButtonState(role: .destructive, action: .retryFetchButtonTapped, label: { TextState("Spróbuj ponownie") })
                            
                            ButtonState(role: .cancel, label: { TextState("Ok") })
                        },
                        message: {
                            TextState("Nie udało się pobrać danych")
                        }
                    )
                )
                return .none

            case .navigateToDetails(let character, let isFavorite):
                state.destination = .characterDetails(.init(character: character, isFavorite: isFavorite))
                return .none
            
            case .destination(.presented(.alert(.retryFetchButtonTapped))):
                return .send(.loadNextPage)
                            
            case .destination(.presented(.characterDetails(.delegate(.favoriteButtonTapped)))):
                state.favoriteIds = favoritesManager.loadIds()
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
    
    private func fetchCharactersEffect(pageId: Int) -> Effect<Action> {
        .run { send in
            await send(
                .fetchResponse(
                    TaskResult {
                        try await apiClient.fetchCharacters(pageId)
                    }
                )
            )
        }
    }
    
}
