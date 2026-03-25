//
//  String+formattedAirDate.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import UIKit

extension String {
    var formattedDateFromAPI: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MMMM d, yyyy"
        inputFormatter.locale = Locale(identifier: "en_US")

        guard let date = inputFormatter.date(from: self) else {
            return self
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .long
        outputFormatter.locale = Locale(identifier: "pl_PL")
        
        return outputFormatter.string(from: date)
    }
}
