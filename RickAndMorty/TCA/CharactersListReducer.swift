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
        var isPageLoading = false
        var paginationFailed = false
        var showErrorAlert = false
    }
    
    enum Action {
        case onAppear
        case startInitialLoad
        case loadNextPage
        case fetchResponse(TaskResult<CharactersResponse>)
        case retryFetchData
        case dismissAlert
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.favoritesManager) var favoritesManager
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.favoriteIds = favoritesManager.loadIds()
            return .none
            
        case .startInitialLoad:
            state.viewState = .loading
            state.allCharacters = []
            state.pageId = 1
            state.hasMorePages = true
            state.isPageLoading = true
            return .run { [pageId = state.pageId] send in
                let result = await TaskResult {
                    try await apiClient.fetchCharacters(pageId)
                }
                
                await send(.fetchResponse(result))
            }
            
        case .loadNextPage:
            guard !state.isPageLoading, state.hasMorePages, !state.paginationFailed else { return .none }
            state.isPageLoading = true
            return .run { [pageId = state.pageId] send in
                let result = await TaskResult {
                    try await apiClient.fetchCharacters(pageId)
                }
                
                await send(.fetchResponse(result))
            }
            
        case let .fetchResponse(.success(response)):
            state.isPageLoading = false
            state.paginationFailed = false
            
            state.allCharacters.append(contentsOf: response.results)
            state.hasMorePages = response.info.nextPageExist
            state.pageId += 1
            
            if state.allCharacters.isEmpty {
                state.viewState = .empty
            } else {
                state.viewState = .list(state.allCharacters)
            }
            return .none
            
        case .fetchResponse(.failure):
            state.isPageLoading = false
            if state.allCharacters.isEmpty {
                state.viewState = .error
            } else {
                state.paginationFailed = true
                state.showErrorAlert = true
            }
            return .none
            
        case .retryFetchData:
            state.paginationFailed = false
            if state.allCharacters.isEmpty {
                state.viewState = .loading
            }
            return .send(.loadNextPage)
            
        case .dismissAlert:
            state.showErrorAlert = false
            return .none
        }
    }
}
