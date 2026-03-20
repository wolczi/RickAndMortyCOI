//
//  EpisodeRow.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI


struct EpisodeRow: View {
    let episodeURL: String
    
    var episodeID: Int {
        Int(episodeURL.components(separatedBy: "/").last ?? "") ?? 0
    }
    
    var body: some View {
        NavigationLink(destination: EpisodeDetailsView(episodeID: episodeID)) {
            HStack {
                Image(systemName: "tv")
                    .foregroundColor(.secondary)
                Text("Odcinek \(episodeID.description)")
                    .font(.subheadline)
                Spacer()
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}
