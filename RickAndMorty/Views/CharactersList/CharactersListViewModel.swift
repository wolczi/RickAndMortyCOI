//
//  CharactersListViewModel.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import SwiftUI
import Combine
import Dependencies

@MainActor
final class CharactersListViewModel: ObservableObject {
    @Dependency(\.apiClient) var apiClient
    
    enum ViewState: Equatable {
        case initial
        case loading
        case empty
        case list([Character])
        case error
    }
    
    @Published private(set) var viewState: ViewState = .initial
    @Published private(set) var allCharacters: [Character] = []
    
    @Published var showErrorAlert = false
    
    private var isPageLoading = false
    @Published var paginationFailed = false
    
    private var pageId = 1
    var hasMorePages = true
    
    func startInitialLoad() {
        resetToInitialState()
        viewState = .loading
        Task { await fetchData() }
    }
    
    func loadNextPage() {
        guard !isPageLoading && !paginationFailed && hasMorePages else { return }
        Task { await fetchData() }
    }
    
    private func fetchData() async {
        isPageLoading = true
        
        do {
            let response = try await apiClient.fetchCharacters(page: pageId)
            
            if pageId == 1 && response.results.isEmpty {
                viewState = .empty
                isPageLoading = false
                return
            }
            
            allCharacters.append(contentsOf: response.results)
            hasMorePages = response.info.nextPageExist
            pageId += 1
            
            paginationFailed = false
            viewState = .list(allCharacters)
            
        } catch {
            if allCharacters.isEmpty {
                viewState = .error
            } else {
                paginationFailed = true
                showErrorAlert = true
            }
        }
        
        isPageLoading = false
    }
    
    func retryFetchData() {
        paginationFailed = false
        
        if allCharacters.isEmpty {
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
        paginationFailed = false
        isPageLoading = false
    }
}
