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
    
    let apiClient = APIClient()
    
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
                    initialView
                case .list:
                    listView
                }
            }
            .navigationTitle("Rick and Morty")
            .alert("Błąd pobierania", isPresented: $showErrorAlert) {
                errorAlertContent
            } message: {
                Text(errorMessage)
            }
        }
        .overlay {
            loadingView
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        if isLoading && viewState == .initial {
            ZStack {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                
                ProgressView("Pobieranie...")
                    .scaleEffect(1.2)
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.thickMaterial)
                    )
            }
        }
    }
    
    @ViewBuilder
    private var errorAlertContent: some View {
        Button(
            "Spróbuj ponownie",
            action: {
                retryFetchData()
            }
        )
        Button("Anuluj", role: .cancel) { }
    }
    
    private var initialView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("Brak bohaterów")
                    .font(.title2.bold())
                
                Text("Naciśnij przycisk, aby wczytać listę postaci z serialu.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Button(action: startInitialLoad) {
                Text("Wczytaj listę")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 50)
        }
    }
    
    private var listView: some View {
        List {
            ForEach(characters) { character in
                HStack(spacing: 15) {
                    KFImage(URL(string: character.image))
                        .placeholder {  Image(systemName: "person.crop.circle.badge.exclamationmark") }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text(character.name)
                }
                .padding(.vertical, 4)
                .onAppear {
                    if character.id == characters.last?.id && hasMorePages && !isLoading {
                        loadNextPage()
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
    }
    
    private func startInitialLoad() {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
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
        //try? await Task.sleep(nanoseconds: 2_000_000_000)
        
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
