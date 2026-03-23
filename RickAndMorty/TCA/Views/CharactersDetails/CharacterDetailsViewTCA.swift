//
//  CharacterDetailsViewTCA.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 23/03/2026.
//

import SwiftUI
import ComposableArchitecture

struct CharacterDetailsViewTCA: View {
    let store: StoreOf<CharacterDetailsReducer>
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    CharacterHeaderImage(imageUrl: store.character.image)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        primaryInfoSection
                        
                        CharacterDetailedSpecsSection(character: store.character)
                        
                        CharacterEpisodesSection(episodes: store.character.episode)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(store.character.name)
            .navigationBarTitleDisplayMode(.inline)
        }
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
}
