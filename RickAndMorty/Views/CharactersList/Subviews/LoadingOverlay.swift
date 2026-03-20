//
//  LoadingOverlay.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI

struct LoadingOverlay: View {
    let isLoading: Bool
    
    var body: some View {
        if isLoading {
            ZStack {
                Color.black.opacity(0.1).ignoresSafeArea()
                ProgressView("Pobieranie...")
                    .padding(30)
                    .background(.thickMaterial)
                    .cornerRadius(15)
            }
        }
    }
}
