//
//  CharactersListViewTCA.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 23/03/2026.
//


import SwiftUI
import ComposableArchitecture

struct CharactersListViewTCA: View {
    let store: StoreOf<CharactersListReducer>
    
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
                .navigationTitle("Lista bohaterów")
                .onAppear { store.send(.onAppear) }
                .alert(
                    "Błąd",
                    isPresented: Binding(
                        get: { store.showErrorAlert },
                        set: { _ in store.send(.dismissAlert) }
                    )
                ) {
                    Button("Spróbuj ponownie") { store.send(.retryFetchData) }
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Nie udało się pobrać danych")
                }
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
                        isFavorite: store.favoriteIds.contains(character.id)
                    )
                }
            }
            
            if store.hasMorePages {
                if store.paginationFailed {
                    paginationErrorView
                } else {
                    ListLoadingIndicator()
                        .id(UUID())
                        .onAppear {
                            store.send(.loadNextPage)
                        }
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
