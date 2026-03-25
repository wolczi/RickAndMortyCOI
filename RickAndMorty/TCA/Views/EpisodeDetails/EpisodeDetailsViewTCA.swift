//
//  EpisodeDetailsViewTCA.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 23/03/2026.
//

import SwiftUI
import ComposableArchitecture

struct EpisodeDetailsViewTCA: View {
    let store: StoreOf<EpisodeDetailsReducer>
    
    var body: some View {
        WithPerceptionTracking {
            Group {
                switch store.viewState {
                case .loading:
                    ProgressView("Pobieranie danych...")
                    
                case let .error(message):
                    ErrorStateView(message: message) {
                        store.send(.fetchEpisode)
                    }
                    
                case let .loadedEpisode(episode):
                    EpisodeContentView(episode: episode)
                }
            }
            .navigationTitle("Szczegóły odcinka")
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

private struct EpisodeContentView: View {
    let episode: Episode
    
    var body: some View {
        List {
            Section(header: Text("Informacje ogólne")) {
                DetailRow(label: "Nazwa", value: episode.name, icon: "tv")
                DetailRow(label: "Data emisji", value: episode.airDate.formattedDateFromAPI, icon: "calendar")
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
