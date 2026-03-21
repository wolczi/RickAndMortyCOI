//
//  CharacterEpisodesSection.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import SwiftUI

struct CharacterEpisodesSection: View {
    let episodes: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Odcinki")
                .font(.title2.bold())
            
            LazyVStack(spacing: 10) {
                ForEach(episodes, id: \.self) { url in
                    EpisodeRow(episodeURL: url)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
