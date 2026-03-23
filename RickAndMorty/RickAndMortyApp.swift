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
    var body: some Scene {
        WindowGroup {
            CharactersListViewTCA(
                store: Store(
                    initialState: CharactersListReducer.State(),
                    reducer: {
                        CharactersListReducer()
                    })
            )
        }
    }
}
