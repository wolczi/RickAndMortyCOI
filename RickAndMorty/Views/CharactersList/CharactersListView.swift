//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 18/03/2026.
//

import SwiftUI
import Kingfisher

struct CharactersListView: View {
    @AppStorage("favorites_key") var favoriteIds: Set<Int> = []
    
    @StateObject private var viewModel: CharactersListViewModel = .init()
    
    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.viewState {
                case .initial:
                    InitialView(action: viewModel.startInitialLoad)
                    
                case .loading:
                    ProgressView("Pobieranie bohaterów...")
                    
                case .empty:
                    NoCharactersView()
                    
                case .error:
                    ErrorStateView(action: viewModel.retryFetchData)
                    
                case .list(let characters):
                    listView(characters: characters)
                }
            }
            .navigationTitle("Lista bohaterów")
            .alert("Błąd", isPresented: $viewModel.showErrorAlert) {
                Button("Spróbuj ponownie", action: viewModel.retryFetchData)
                Button("OK", role: .cancel) { }
            } message: {
                Text("Nie udało się pobrać danych")
            }
        }
    }
    
    private func listView(characters: [Character]) -> some View {
        List {
            ForEach(characters) { character in
                NavigationLink {
                    CharacterDetailsView(character: character)
                } label: {
                    CharacterRow(
                        character: character,
                        isFavorite: favoriteIds.contains(character.id)
                    )
                }
            }
            
            if viewModel.hasMorePages {
                if viewModel.paginationFailed {
                    Button(action: viewModel.retryFetchData) {
                        HStack {
                            Spacer()
                            Text("Błąd ładowania. Spróbuj ponownie.")
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    }
                    .padding()
                } else {
                    ListLoadingIndicator()
                        .id(UUID())
                        .task {
                            viewModel.loadNextPage()
                        }
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.startInitialLoad()
        }
    }
}
