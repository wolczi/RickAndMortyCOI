//
//  CharactersListViewModel.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import SwiftUI
import Combine

@MainActor
final class CharactersListViewModel: ObservableObject {
    @DIResolved private var apiClient: APIClientProtocol
    @DIResolved var favoritesManager: FavoritesManager
    
    enum ViewState: Equatable {
        case initial
        case loading
        case empty
        case list([Character], isPageLoading: Bool)
        case error
    }
    
    @Published private(set) var viewState: ViewState = .initial
    @Published private(set) var allCharacters: [Character] = []
    @Published private(set) var isLoading = false
    
    @Published var showErrorAlert = false
    
    private var pageId = 1
    private var hasMorePages = true
    private var cancellables = Set<AnyCancellable>()
    
    var showLoadingOverlay: Bool {
        viewState == .loading
    }
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        favoritesManager.$favoriteIds
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    func startInitialLoad() {
        viewState = .loading
        
        Task {
            await fetchData()
        }
    }
    
    func loadNextPage(currentCharacter character: Character) {
        guard case .list(let currentList, let isPageLoading) = viewState,
              !isPageLoading,
              character.id == currentList.last?.id,
              hasMorePages else { return }
        
        viewState = .list(allCharacters, isPageLoading: true)
        
        Task {
            await fetchData()
        }
    }
    
    private func fetchData() async {
        try? await Task.sleep(nanoseconds: 250_000_000)
        
        do {
            let response = try await apiClient.fetchCharacters(page: pageId)
            
            if pageId == 1 && response.results.isEmpty {
                viewState = .empty
                return
            }
            
            allCharacters.append(contentsOf: response.results)
            hasMorePages = response.info.nextPageExist
            pageId += 1
            
            viewState = .list(allCharacters, isPageLoading: false)
            
        } catch {
            if allCharacters.isEmpty {
                viewState = .error
            } else {
                viewState = .list(allCharacters, isPageLoading: false)
                showErrorAlert = true
            }
        }
    }
    
    func retryFetchData() {
        if !allCharacters.isEmpty {
            viewState = .list(allCharacters, isPageLoading: true)
        } else {
            viewState = .loading
        }
        
       Task { await fetchData() }
    }
    
    func resetToInitialState() {
        viewState = .initial
        allCharacters = []
        pageId = 1
        hasMorePages = true
        showErrorAlert = false
    }

}
