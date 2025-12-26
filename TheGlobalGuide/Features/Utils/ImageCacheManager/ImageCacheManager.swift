//
//  ImageCacheManager.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 25/12/25.
//
import Foundation
import UIKit

protocol ImageCacheManagerProtocol {
    func save(data: Data, id: String)
    func load(id: String) -> Data?
}


struct ImageCacheManager: ImageCacheManagerProtocol {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    private func getFileURL(for id: String) -> URL? {
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentsURL.appendingPathComponent("\(id)_flag.png")
    }
    
    func save(data: Data, id: String) {
        guard let url = getFileURL(for: id) else { return }
        do {
            try data.write(to: url)
        } catch {
            print("Error caching image: \(error)")
        }
    }
    
    func load(id: String) -> Data? {
        guard let url = getFileURL(for: id),
              fileManager.fileExists(atPath: url.path) else { return nil }
        
        return try? Data(contentsOf: url)
    }
}
