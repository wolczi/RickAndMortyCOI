//
//  InitialView.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI

struct InitialView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image("rickAndMortyLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            
            VStack(spacing: 8) {
                Text("Brak bohaterów")
                    .font(.title2.bold())
                Text("Naciśnij przycisk, aby wczytać listę postaci.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Button(action: action) {
                Text("Wczytaj listę")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 50)
        }
    }
}
