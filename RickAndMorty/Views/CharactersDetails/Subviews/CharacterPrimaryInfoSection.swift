//
//  CharacterPrimaryInfoSection.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import SwiftUI

struct CharacterPrimaryInfoSection: View {
    let name: String
    let status: Character.Status
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(name)
                    .font(.system(size: 32, weight: .bold))
                
                Spacer()
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .font(.title2)
                        .foregroundColor(.yellow)
                        .contentShape(Rectangle())
                }
            }
            
            StatusBadge(status: status)
        }
        .padding(.horizontal)
    }
}
