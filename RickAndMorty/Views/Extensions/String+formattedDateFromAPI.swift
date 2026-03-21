//
//  String+formattedAirDate.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import UIKit

extension String {
    func formattedDateFromAPI() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MMMM d, yyyy"
        inputFormatter.locale = Locale(identifier: "en_US")

        guard let date = inputFormatter.date(from: self) else {
            return self
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .long
        //outputFormatter.timeStyle = .none
        outputFormatter.locale = Locale(identifier: "pl_PL")
        
        return outputFormatter.string(from: date)
    }
}
