//
//  DetailRow.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI

struct DetailRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 25)
            VStack(alignment: .leading) {
                Text(label).font(.caption).foregroundColor(.secondary)
                Text(value).font(.body).fontWeight(.medium)
            }
        }
    }
}
