//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 18/03/2026.
//

import SwiftUI
import Kingfisher

struct CharactersListView: View {
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
                    NoCharactersView(action: viewModel.retryFetchData)
                    
                case .error:
                    ErrorStateView(action: viewModel.retryFetchData)
                    
                case .list(let characters, let isPageLoading):
                    listView(characters: characters, isPageLoading: isPageLoading)
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
    
    private func listView(characters: [Character], isPageLoading: Bool) -> some View {
        List {
            ForEach(characters) { character in
                NavigationLink {
                    CharacterDetailsView(character: character)
                } label: {
                    CharacterRow(
                        character: character,
                        isFavorite: viewModel.favoritesManager.isFavorite(character.id)
                    )
                }
                .onAppear {
                    viewModel.loadNextPage(currentCharacter: character)
                }
            }
            
            if isPageLoading {
                ListLoadingIndicator()
                    .id(UUID())
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Wróć") {
                    viewModel.resetToInitialState()
                }
            }
        }
    }
}
