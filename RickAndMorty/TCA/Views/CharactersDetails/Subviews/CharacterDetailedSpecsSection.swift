//
//  CharacterDetailedSpecsSection.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import SwiftUI

struct CharacterDetailedSpecsSection: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider().padding(.bottom, 8)
            
            DetailRow(label: "Płeć", value: character.gender.localized, icon: "person.fill")
            DetailRow(label: "Pochodzenie", value: character.origin.displayName, icon: "globe")
            DetailRow(label: "Lokalizacja", value: character.location.name, icon: "mappin.and.ellipse")
        }
        .padding(.horizontal)
    }
}
