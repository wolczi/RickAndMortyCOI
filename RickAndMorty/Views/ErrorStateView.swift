//
//  ErrorStateView.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String?
    let action: () -> Void
    
    init(message: String? = nil, action: @escaping () -> Void) {
        self.message = message
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
                .padding(.bottom, 5)
            
            Text("Ups! Coś poszło nie tak")
                .font(.title2.bold())
            
            Text(message ?? "Nie udało się pobrać danych.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: action) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Spróbuj ponownie")
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
