//
//  PersistenceManager.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 07/12/25.
//

import Foundation
internal import UniformTypeIdentifiers

protocol PersistenceManagerProtocol {
    func save<T: Codable>(_ data: T, key: String)
    func load<T: Codable>(key: String, as type: T.Type) -> T?
}

final class PersistenceManager: PersistenceManagerProtocol, @unchecked Sendable{
    
    private let fileManager: FileManager
    
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    private func fileURL(for key: String) throws -> URL {
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectory.appendingPathComponent(key, conformingTo: .json)
    }
    
    func save<T: Codable>(_ data: T, key: String) {
        do {
            let url = try fileURL(for: key)
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: url)
        } catch {
            print("Error saving data to file: \(error)")
        }
    }
    
    func load<T: Codable>(key: String, as type: T.Type) -> T? {
        do {
            let url = try fileURL(for: key)
            guard fileManager.fileExists(atPath: url.path) else { return nil }
            
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(type, from: data)
            return decoded
        } catch {
            print("Error loading data from file: \(error)")
            return nil
        }
    }
}
