//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI
import Kingfisher

@MainActor
struct CharacterDetailsView: View {
    
    let character: Character
    
    var body: some View {
        VStack {
            Text(character.name)
        }
    }
    
}
