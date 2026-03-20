//
//  EpisodeRow.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI


struct EpisodeRow: View {
    let episodeURL: String
    
    var extractedEpisodeNumber: String {
        episodeURL.components(separatedBy: "/").last ?? "?"
    }
    
    var body: some View {
        HStack {
            Image(systemName: "tv")
                .foregroundColor(.secondary)
            Text("Odcinek \(extractedEpisodeNumber)")
                .font(.subheadline)
            Spacer()
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}
