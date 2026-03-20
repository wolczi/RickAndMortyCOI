//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 18/03/2026.
//

import SwiftUI
import Kingfisher

@MainActor
struct StartView: View {
    
    enum ViewState {
        case initial
        case list
    }
    
    let apiClient = APIClient()
    
    @State private var viewState: ViewState = .initial
    @State private var characters: [Character] = []
    @State private var isLoading = false
    @State private var pageId = 1
    @State private var hasMorePages = false
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                switch viewState {
                case .initial:
                    welcomeView
                case .list:
                    listView
                }
                
                if isLoading && viewState == .initial {
                    ZStack {
                        Color(UIColor.systemBackground)
                        loadingView
                    }
                    .transition(.opacity)
                }
            }
            .navigationTitle("Rick and Morty")
            .alert("Błąd pobierania", isPresented: $showErrorAlert) {
                Button("Spróbuj ponownie", action: { loadData() })
                Button("Anuluj", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private var loadingView: some View {
        ProgressView("Pobieranie...")
            .scaleEffect(1.2)
    }
    
    private var listView: some View {
        List {
            ForEach(characters) { character in
                HStack(spacing: 15) {
                    KFImage(URL(string: character.image))
                        .placeholder {  ProgressView() }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text(character.name)
                }
                .padding(.vertical, 4)
                .onAppear {
                    if character.id == characters.last?.id && hasMorePages && !isLoading {
                        loadData()
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
    
    private var welcomeView: some View {
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
            
            Button {
                loadData(isInitial: true)
            } label: {
                Text("Wczytaj listę")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 50)
        }
    }

    private func loadData(isInitial: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        Task {
            await fetchData()
            
            if isInitial {
                viewState = .list
            }
            isLoading = false
        }
    }

    private func fetchData() async {
        //try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        do {
            let response = try await apiClient.fetchCharacters(page: pageId)
            characters.append(contentsOf: response.results)
            hasMorePages = response.info.nextPageExist
            pageId += 1
        } catch {
            print("Błąd: \(error)")
            errorMessage = "Nie udało się pobrać danych. Sprawdź połączenie."
            showErrorAlert = true
        }
    }
}
