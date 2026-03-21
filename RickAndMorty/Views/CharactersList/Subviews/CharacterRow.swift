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
            KFImage(URL(string: character.image))
                .placeholder { Image(systemName: "person.circle") }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(character.name)
            
            Spacer()
            
            if isFavorite {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.yellow)
            }
        }
        .padding(.vertical, 4)
    }
}
