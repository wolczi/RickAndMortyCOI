//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI
import Kingfisher

struct CharacterDetailsView: View {

    @EnvironmentObject private var favoritesManager: FavoritesManager
    
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                KFImage(URL(string: character.image))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .clipped()
                    .shadow(radius: 10)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(character.name)
                            .font(.system(size: 32, weight: .bold))
                        Spacer()
                        
                        Button(action: {
                            favoritesManager.toggleFavorite(character.id)
                        }, label: {
                            Image(systemName: favoritesManager.isFavorite(character.id) ? "star.fill" : "star")
                                .font(.title)
                                .foregroundColor(.yellow)
                        })
                    }
                    
                    StatusBadge(status: character.status)
                    
                    Divider().padding(.vertical, 5)
                    
                    DetailRow(label: "Płeć", value: character.gender.localized, icon: "person.fill")
                    DetailRow(label: "Pochodzenie", value: character.origin.name, icon: "globe")
                    DetailRow(label: "Lokalizacja", value: character.location.name, icon: "mappin.and.ellipse")
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Odcinki")
                        .font(.title2.bold())
                        .padding(.horizontal)
                    
                    LazyVStack(spacing: 10) {
                        ForEach(character.episode, id: \.self) { url in
                            EpisodeRow(episodeURL: url)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
