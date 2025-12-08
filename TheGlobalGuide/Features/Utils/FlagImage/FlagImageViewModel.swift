//
//  FlagImageViewModel.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 06/12/25.
//

import Foundation
import UIKit
import Combine

class FlagImageViewModel: ObservableObject {
    
    let networkManager: NetworkManagerProtocol
    private let fileManager = FileManager.default
    
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func loadImage(from urlString: String?, countryId: String) async {
        
        guard let urlString = urlString else { return }
        
        guard image == nil else { return }
        
        if let localImg = loadLocalImage(countryId: countryId) {
            await MainActor.run {
                self.image = localImg
            }
            return
        }
        
        await MainActor.run {
            isLoading = true
        }
        defer { Task { await MainActor.run { isLoading = false }}}
        
        do {
            let data = try await networkManager.getFlagImage(for: urlString)
            if let uiImage = UIImage(data: data) {
                
                saveImageLocally(data: data, countryId: countryId)
                
                await MainActor.run {
                    self.image = uiImage
                }
            }
        } catch {
            await MainActor.run {
                self.image = UIImage(systemName: "flag.slash.fill")
            }
        }
    }
    
    // MARK: - Local save
        
    private func getDocumentsDirectory() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func loadLocalImage(countryId: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(countryId)_flag.png")
        
        if fileManager.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        }
        return nil
    }
    
    private func saveImageLocally(data: Data, countryId: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(countryId)_flag.png")
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error guardando imagen localmente: \(error)")
        }
    }
}
