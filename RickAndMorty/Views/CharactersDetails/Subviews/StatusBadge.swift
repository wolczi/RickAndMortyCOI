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
            .background(status == .alive ? Color.green.opacity(0.2) : status == .dead ? Color.red.opacity(0.2) : Color.gray.opacity(0.2))
            .foregroundColor(status == .alive ? .green : status == .dead ? .red : .gray)
            .cornerRadius(8)
    }
}
