//
//  EpisodeDetailsView.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI

struct EpisodeDetailsView: View {
    let episodeID: Int
    @Environment(\.apiClient) private var apiClient
    
    @State private var episode: Episode?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        List {
            if let episode = episode {
                Section(header: Text("Informacje ogólne")) {
                    DetailRow(label: "Nazwa", value: episode.name, icon: "tv")
                    DetailRow(label: "Data emisji", value: episode.airDate, icon: "calendar")
                    DetailRow(label: "Kod odcinka", value: episode.episode, icon: "tag")
                }
                
                Section(header: Text("Postacie")) {
                    Text("W tym odcinku występuje \(episode.characters.count) postaci.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Szczegóły odcinka")
        .overlay {
            if isLoading {
                ProgressView("Pobieranie danych...")
            } else if let error = errorMessage {
                VStack {
                    Text(error).foregroundColor(.red)
                    Button("Spróbuj ponownie") { Task { await fetchEpisode() } }
                }
            }
        }
        .task {
            await fetchEpisode()
        }
    }

    private func fetchEpisode() async {
        isLoading = true
        do {
            episode = try await apiClient.fetchEpisode(id: episodeID)
            isLoading = false
        } catch {
            errorMessage = "Nie udało się wczytać odcinka"
            isLoading = false
        }
    }
}
