//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 18/03/2026.
//

import SwiftUI
import ComposableArchitecture

@main
struct RickAndMortyApp: App {
    @Dependency(\.favoritesManager) var favoritesManager
    
    var body: some Scene {
        WindowGroup {
            CharactersListViewTCA(
                store: Store(
                    initialState: CharactersListReducer.State(favoriteIds: favoritesManager.loadIds()),
                    reducer: {
                        CharactersListReducer()
                    })
            )
        }
    }
}
