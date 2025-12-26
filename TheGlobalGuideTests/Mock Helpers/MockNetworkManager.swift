//
//  MockNetworkManager.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 24/12/25.
//
import Foundation
import UIKit
@testable import TheGlobalGuide

@MainActor
final class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnError = false
    var mockCountries: [Country] = []
    var mockFlagData: Data?
    
    func fetchCountries() async throws -> [Country] {
        if shouldReturnError {
            throw NetworkError.serverError(statusCode: 500)
        }
        return mockCountries
    }
    
    func getFlagImage(for urlString: String) async throws -> Data {
        if shouldReturnError {
            throw NetworkError.invalidURL
        }
        return mockFlagData ?? Data()
    }
}
