//
//  Country.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 03/12/25.
//

import Foundation

struct Country: Codable, Identifiable, Equatable {
    
    var id: String { cca3 }
    let cca3: String
    
    let name: Name
    let capital: [String]?
    let region: String
    let population: Int
    let flags: Flags
    
    let currencies: [String: Currency]?
    let languages: [String: String]?
    let timezones: [String]
}

struct Name: Codable, Equatable {
    let common: String
    let official: String
}

struct Flags: Codable, Equatable {
    let png: String
}

struct Currency: Codable, Equatable {
    let name: String
    let symbol: String?
}

//MARK: - Extension for computed vars
extension Country {
    
    var commonName: String { name.common }
    var officialName: String { name.official }
    var capitalName: String { capital?.first ?? "N/A" }
    
    private static let populationFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var populationFormatted: String {
        return Self.populationFormatter.string(from: NSNumber(value: population)) ?? "\(population)"
    }
    
    var currencyList: String {
        guard let currencies = currencies else { return "N/A" }
        
        return currencies.values.map{ "\($0.name) \($0.symbol ?? "")" }.joined(separator: ", ")
    }
    
    var languageList: String {
        guard let languages = languages else { return "N/A" }
        return languages.values.joined(separator: ", ")
    }
}
