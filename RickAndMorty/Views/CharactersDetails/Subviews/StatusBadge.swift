//
//  StatusBadge.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 20/03/2026.
//

import SwiftUI

struct StatusBadge: View {
    let status: Character.Status
    
    var body: some View {
        Text(status.localized)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .cornerRadius(8)
    }
}
