//
//  EpisodeDetailsReducer.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 23/03/2026.
//

import ComposableArchitecture

@Reducer
struct EpisodeDetailsReducer {
    @ObservableState
    struct State: Equatable, Identifiable {
        enum ViewState: Equatable {
            case loading
            case loadedEpisode(Episode)
            case error(String)
        }
        
        var id: Int { episodeID }
        let episodeID: Int
        var viewState: ViewState = .loading
    }
    
    enum Action {
        case onAppear
        case fetchEpisode
        case fetchResponse(TaskResult<Episode>)
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchEpisode)
                
            case .fetchEpisode:
                state.viewState = .loading
                return .run { [id = state.episodeID] send in
                    await send(
                        .fetchResponse(
                            TaskResult { try await apiClient.fetchEpisode(id) }
                        )
                    )
                }
                
            case let .fetchResponse(.success(episode)):
                state.viewState = .loadedEpisode(episode)
                return .none
                
            case .fetchResponse(.failure):
                state.viewState = .error("Nie udało się wczytać szczegółów odcinka.")
                return .none
            }
        }
    }
}
