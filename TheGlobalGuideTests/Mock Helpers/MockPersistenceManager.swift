//
//  MockPersistenceManager.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 24/12/25.
//
import Foundation
@testable import TheGlobalGuide

@MainActor
final class MockPersistenceManager: PersistenceManagerProtocol {
    
    var mockLoadResult: Any?
    var saveCalled = false
    var loadCalled = false
    
    func save<T: Encodable>(_ data: T, key: String) {
        saveCalled = true
    }
    
    func load<T: Decodable>(key: String, as type: T.Type) -> T? {
        loadCalled = true
        return mockLoadResult as? T
    }
}
