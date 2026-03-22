//
//  CharacterRow.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI
import Kingfisher

struct CharacterRow: View {
    let character: Character
    let isFavorite: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Text(character.name)
            
            Spacer()
            
            if isFavorite {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.yellow)
            }
        }
        .padding(.vertical, 20)
    }
}
