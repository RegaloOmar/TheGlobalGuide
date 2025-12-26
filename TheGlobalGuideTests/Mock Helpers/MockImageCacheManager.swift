//
//  MockImageCacheManager.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 25/12/25.
//
import Foundation
@testable import TheGlobalGuide

@MainActor
final class MockImageCacheManager: ImageCacheManagerProtocol {
    
    var store: [String: Data] = [:]
    var saveCalled = false
    var loadCalled = false
    
    func save(data: Data, id: String) {
        saveCalled = true
        store[id] = data
    }
    
    func load(id: String) -> Data? {
        loadCalled = true
        return store[id]
    }
}
