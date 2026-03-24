//
//  CharacterDetailsViewTCA.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 23/03/2026.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct CharacterDetailsViewTCA: View {
    let store: StoreOf<CharacterDetailsReducer>
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    characterHeaderImage
                    
                    VStack(alignment: .leading, spacing: 20) {
                        primaryInfoSection
                        
                        characterDetailedSpecsSection
                        
                        characterEpisodesSection
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(store.character.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var characterHeaderImage: some View {
        KFImage(URL(string: store.character.image))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .clipped()
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var primaryInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(store.character.name)
                    .font(.system(size: 32, weight: .bold))
                
                Spacer()
                
                Button(action: {
                    store.send(.favoriteButtonTapped)
                }, label: {
                    Image(systemName: store.isFavorite ? "star.fill" : "star")
                        .font(.title2)
                        .foregroundColor(.yellow)
                        .contentShape(Rectangle())
                })
            }
            
            StatusBadge(status: store.character.status)
        }
        .padding(.horizontal)
    }
    
    private var characterDetailedSpecsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider().padding(.bottom, 8)
            
            DetailRow(label: "Płeć", value: store.character.gender.localized, icon: "person.fill")
            DetailRow(label: "Pochodzenie", value: store.character.origin.displayName, icon: "globe")
            DetailRow(label: "Lokalizacja", value: store.character.location.name, icon: "mappin.and.ellipse")
        }
        .padding(.horizontal)
    }
    
    private var characterEpisodesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Odcinki")
                .font(.title2.bold())
            
            LazyVStack(spacing: 10) {
                ForEach(store.character.episode, id: \.self) { url in
                    episodeRow(episodeURL: url)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private func episodeRow(episodeURL: String) -> some View {
        let episodeID: Int = Int(episodeURL.components(separatedBy: "/").last ?? "") ?? 0
        
        NavigationLinkStore(
            self.store.scope(state: \.$episodeDetails, action: \.episodeDetails),
            id: episodeID,
            onTap: { self.store.send(.navigateToEpisodeDetails(episodeID)) },
            destination: EpisodeDetailsViewTCA.init,
            label: {
                HStack {
                    Image(systemName: "tv")
                        .foregroundColor(.secondary)
                    Text("Odcinek \(episodeID.description)")
                        .font(.subheadline)
                    Spacer()
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            }
        )
        .buttonStyle(.plain)
        
    }

}
