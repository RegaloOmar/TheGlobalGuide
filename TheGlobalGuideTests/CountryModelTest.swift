//
//  CountryModelTest.swift
//  TheGlobalGuideTests
//
//  Created by Omar Regalado Mendoza on 25/12/25.
//

import XCTest
@testable import TheGlobalGuide

final class CountryModelTest: XCTestCase {

    func testPopulationFormatted() {
        let country = Country.mock(id: "SWE", name: "Sweden", region: "Europe", population: 1235869)
        XCTAssertEqual(country.populationFormatted, "1,235,869")
    }
    
    func testCurrencyList() {
        let currencies = [
            "USD": Currency(name: "Dollar", symbol: "$"),
            "EUR": Currency(name: "Euro", symbol: "€")
        ]
        
        let country = Country.mock(id: "WKD", name: "Wakanda", currencies: currencies)
        
        let result = country.currencyList
        
        XCTAssertTrue(result.contains("Dollar"))
        XCTAssertTrue(result.contains("Euro"))
    }
}
