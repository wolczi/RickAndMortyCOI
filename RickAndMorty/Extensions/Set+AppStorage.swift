//
//  Set+AppStorage.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 22/03/2026.
//

import SwiftUI

extension Set: @retroactive RawRepresentable where Element == Int {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(Set<Int>.self, from: data)
        else { return nil }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else { return "[]" }
        return result
    }
}
