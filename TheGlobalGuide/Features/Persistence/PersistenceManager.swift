//
//  PersistenceManager.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 07/12/25.
//

import Foundation
internal import UniformTypeIdentifiers

struct PersistenceManager {
    
    static private func fileURL(for Key: String) throws -> URL {
        let fileManager = FileManager.default
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectory.appendingPathComponent(Key, conformingTo: .json)
    }
    
    static func save<T: Codable>(_ data: T, key: String) {
        do {
            let url = try fileURL(for: key)
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: url)
        } catch {
            
        }
    }
    
    static func load<T: Codable>(key: String, as type: T.Type) -> T? {
        do {
            let url = try fileURL(for: key)
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(type, from: data)
            return decoded
        } catch {
            return nil
        }
    }
}
