//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI

struct CharacterDetailsView: View {

    @StateObject private var viewModel: CharacterDetailsViewModel
    
    init(character: Character) {
        _viewModel = StateObject(wrappedValue: CharacterDetailsViewModel(character: character))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                CharacterHeaderImage(imageUrl: viewModel.character.image)
                
                VStack(alignment: .leading, spacing: 20) {
                    CharacterPrimaryInfoSection(
                        name: viewModel.character.name,
                        status: viewModel.character.status,
                        isFavorite: viewModel.isFavorite,
                        onFavoriteToggle: viewModel.toggleFavorite
                    )
                    
                    CharacterDetailedSpecsSection(character: viewModel.character)
                    
                    CharacterEpisodesSection(episodes: viewModel.character.episode)
                }
                .padding(.top, 20)
            }
        }
        .navigationTitle(viewModel.character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
