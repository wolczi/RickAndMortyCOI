//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI

struct CharacterDetailsView: View {
    
    @AppStorage("favorites_key") var favoriteIds: Set<Int> = []
    
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                CharacterHeaderImage(imageUrl: character.image)
                
                VStack(alignment: .leading, spacing: 20) {
                    CharacterPrimaryInfoSection(character: character)
                    
                    CharacterDetailedSpecsSection(character: character)
                    
                    CharacterEpisodesSection(episodes: character.episode)
                }
                .padding(.top, 20)
            }
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
