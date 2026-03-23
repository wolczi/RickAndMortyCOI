//
//  NoCharactersView.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import SwiftUI

struct NoCharactersView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.fill.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Nie znaleziono bohaterów")
                .font(.title3.bold())
            
            Text("Wygląda na to, że wymiar, którego szukasz, jest pusty.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}
