//
//  EpisodeDetailsViewModel.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import SwiftUI
import Combine

@MainActor
final class EpisodeDetailsViewModel: ObservableObject {
    @DIResolved private var apiClient: APIClientProtocol
    
    enum ViewState {
        case loading
        case loaded(Episode)
        case error(String)
    }
    
    @Published private(set) var viewState: ViewState = .loading
    
    private let episodeID: Int
    
    init(episodeID: Int) {
        self.episodeID = episodeID
    }
    
    func fetchEpisode() async {
        viewState = .loading
        
        do {
            let episode = try await apiClient.fetchEpisode(id: episodeID)
            viewState = .loaded(episode)
        } catch {
            viewState = .error("Nie udało się wczytać szczegółów odcinka.")
        }
    }
}
