//
//  ExtensionsHelpers.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 24/12/25.
//

import Foundation
@testable import TheGlobalGuide

extension Country {
    static func mock(id: String, name: String, region: String = "Europe", population: Int = 1000, currencies: [String: Currency] = ["currency": Currency(name: "Euro", symbol: "")]) -> Country {
        return Country(
            cca3: id, name: Name(common: name, official: "\(name) Official"),
            capital: ["Capital"],
            region: region,
            population: population,
            flags: Flags(png: "https://mainfacts.com/media/images/coats_of_arms/de.png"),
            currencies: currencies,
            languages: nil,
            timezones: ["UTC - 6"],
            latlng: [0.0, 0.0]
        )
    }
}
