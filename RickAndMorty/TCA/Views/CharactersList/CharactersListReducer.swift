//
//  CharactersListReducer.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import ComposableArchitecture

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
        var showErrorAlert = false
        
        @Presents var characterDetails: CharacterDetailsReducer.State?
    }
    
    enum Action {
        case startInitialLoad
        case loadNextPage
        case fetchResponse(TaskResult<CharactersResponse>)
        case retryFetchData
        case dismissAlert
        case navigateToDetails(Character, Bool)
        case characterDetails(PresentationAction<CharacterDetailsReducer.Action>)
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
                if state.allCharacters.isEmpty {
                    state.viewState = .error
                } else {
                    state.showErrorAlert = true
                }
                state.hasMorePages = false
                return .none
                
            case .retryFetchData:
                if state.allCharacters.isEmpty {
                    state.viewState = .loading
                }
                return .send(.loadNextPage)
                
            case .dismissAlert:
                state.showErrorAlert = false
                return .none
            case .navigateToDetails(let character, let isFavorite):
                state.characterDetails = .init(character: character, isFavorite: isFavorite)
                return .none
            case .characterDetails(.presented(.delegate(.favoriteButtonTapped))):
                state.favoriteIds = favoritesManager.loadIds()
                return .none
            case .characterDetails:
                return .none
            }
        }
        .ifLet(\.$characterDetails, action: \.characterDetails) {
            CharacterDetailsReducer()
        }
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
