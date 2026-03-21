//
//  EpisodeDetailsView.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI

struct EpisodeDetailsView: View {
    @StateObject private var viewModel: EpisodeDetailsViewModel
    
    init(episodeID: Int) {
        _viewModel = StateObject(wrappedValue: EpisodeDetailsViewModel(episodeID: episodeID))
    }
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                ProgressView("Pobieranie danych...")
                
            case .error(let message):
                ErrorStateView(message: message) {
                    Task { await viewModel.fetchEpisode() }
                }
                
            case .loaded(let episode):
                EpisodeContentView(episode: episode)
            }
        }
        .navigationTitle("Szczegóły odcinka")
        .task {
            await viewModel.fetchEpisode()
        }
    }
}

private struct EpisodeContentView: View {
    let episode: Episode
    
    var body: some View {
        List {
            Section(header: Text("Informacje ogólne")) {
                DetailRow(label: "Nazwa", value: episode.name, icon: "tv")
                DetailRow(label: "Data emisji", value: episode.airDate.formattedDateFromAPI(), icon: "calendar")
                DetailRow(label: "Kod odcinka", value: episode.episode, icon: "tag")
            }
            
            Section(header: Text("Postacie")) {
                Text("W tym odcinku występuje \(episode.characters.count) postaci.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
