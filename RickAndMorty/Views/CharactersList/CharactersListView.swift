//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 18/03/2026.
//

import SwiftUI
import Kingfisher

@MainActor
struct CharactersListView: View {
    
    enum ViewState {
        case initial
        case list
    }
    
    @Environment(\.apiClient) private var apiClient
    
    @State private var viewState: ViewState = .initial
    
    @State private var characters: [Character] = []
    
    @State private var isLoading = false
    @State private var pageId = 1
    @State private var hasMorePages = true
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                switch viewState {
                case .initial:
                    InitialView(action: startInitialLoad)
                case .list:
                    listView
                }
            }
            .alert("Błąd pobierania", isPresented: $showErrorAlert) {
                Button("Spróbuj ponownie", action: retryFetchData)
                Button("Anuluj", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
        .overlay {
            LoadingOverlay(isLoading: isLoading && viewState == .initial)
        }
    }
    
    private var listView: some View {
        List {
            ForEach(characters) { character in
                NavigationLink {
                    CharacterDetailsView(character: character)
                } label: {
                    CharacterRow(character: character)
                        .onAppear {
                            if character.id == characters.last?.id && hasMorePages && !isLoading {
                                loadNextPage()
                            }
                        }
                }
            }
            
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .id(UUID())
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Wróć") {
                    resetToInitialState()
                }
            }
        }
        .navigationTitle("Lista bohaterów")
    }
    
    private func resetToInitialState() {
        viewState = .initial
            
        characters = []
        pageId = 1
        hasMorePages = true
        showErrorAlert = false
        errorMessage = ""
    }
    
    private func startInitialLoad() {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            try? await Task.sleep(nanoseconds: 250_000_000)
            
            let success = await fetchData()
            
            isLoading = false
            
            if success {
                viewState = .list
            }
        }
    }

    private func loadNextPage() {
        guard !isLoading && hasMorePages else { return }
        isLoading = true
        
        Task {
            _ = await fetchData()
            isLoading = false
        }
    }
    
    private func retryFetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if viewState == .initial {
                startInitialLoad()
            } else {
                loadNextPage()
            }
        }
    }

    private func fetchData() async -> Bool {
        do {
            let response = try await apiClient.fetchCharacters(page: pageId)
            characters.append(contentsOf: response.results)
            hasMorePages = response.info.nextPageExist
            pageId += 1
            return true
        } catch {
            print("Błąd: \(error)")
            errorMessage = "Nie udało się pobrać danych. Sprawdź połączenie."
            showErrorAlert = true
            return false
        }
    }
}
