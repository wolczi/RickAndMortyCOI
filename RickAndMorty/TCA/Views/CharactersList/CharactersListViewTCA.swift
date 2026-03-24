//
//  CharactersListViewTCA.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 23/03/2026.
//


import SwiftUI
import ComposableArchitecture

struct CharactersListViewTCA: View {
    @Perception.Bindable var store: StoreOf<CharactersListReducer>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationView {
                ZStack {
                    switch store.viewState {
                    case .initial:
                        InitialView { store.send(.startInitialLoad) }
                    case .loading:
                        ProgressView("Pobieranie bohaterów...")
                    case .empty:
                        NoCharactersView()
                    case .error:
                        ErrorStateView { store.send(.retryFetchData) }
                    case let .list(characters):
                        listView(characters: characters)
                    }
                }
                .alert(self.$store.scope(state: \.alert, action: \.alert))
                .navigationTitle("Lista bohaterów")
            }

       }
    }
    
    @ViewBuilder
    private func listView(characters: [Character]) -> some View {
        List {
            ForEach(characters) { character in
                let isFavorite = store.favoriteIds.contains(character.id)
                
                NavigationLinkStore(
                    self.store.scope(state: \.$characterDetails, action: \.characterDetails),
                    id: character.id,
                    onTap: { self.store.send(.navigateToDetails(character, isFavorite)) },
                    destination: CharacterDetailsViewTCA.init,
                    label: {
                        CharacterRow(
                            character: character,
                            isFavorite: isFavorite
                        )
                    }
                )
            }
            
            if store.hasMorePages {
                ListLoadingIndicator()
                    .id(UUID())
                    .onAppear {
                        store.send(.loadNextPage)
                    }
            }
        }
        .listStyle(.plain)
    }
    
    private var paginationErrorView: some View {
        Button {
            store.send(.retryFetchData)
        } label: {
            HStack {
                Spacer()
                Text("Błąd ładowania. Spróbuj ponownie.")
                    .foregroundColor(.blue)
                Spacer()
            }
        }
        .padding()
    }
}
