//
//  CharacterPrimaryInfoSection.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import SwiftUI

struct CharacterPrimaryInfoSection: View {
    @AppStorage("favorites_key") var favoriteIds: Set<Int> = []

    let character: Character
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(character.name)
                    .font(.system(size: 32, weight: .bold))
                
                Spacer()
                
                Button(action: {
                    if favoriteIds.contains(character.id) {
                        favoriteIds.remove(character.id)
                    } else {
                        favoriteIds.insert(character.id)
                    }
                }, label: {
                    Image(systemName: favoriteIds.contains(character.id) ? "star.fill" : "star")
                        .font(.title2)
                        .foregroundColor(.yellow)
                        .contentShape(Rectangle())
                })
            }
            
            StatusBadge(status: character.status)
        }
        .padding(.horizontal)
    }
}
