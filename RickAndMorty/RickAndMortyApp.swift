//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 18/03/2026.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    @StateObject private var favoritesManager = FavoritesManager()
    
    var body: some Scene {
        WindowGroup {
            CharactersListView()
                .environmentObject(favoritesManager)
        }
    }
}
