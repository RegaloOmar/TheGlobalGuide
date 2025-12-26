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
    
    private let networkManager: NetworkManagerProtocol
    private let imageCache: ImageCacheManagerProtocol
    
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    
    init(networkManager: NetworkManagerProtocol = NetworkManager(),
         imageCache: ImageCacheManagerProtocol = ImageCacheManager()) {
        self.networkManager = networkManager
        self.imageCache = imageCache
    }
    
    func loadImage(from urlString: String?, countryId: String) async {
        guard let urlString = urlString else { return }
        
        guard image == nil else { return }
        
        if let cachedData = imageCache.load(id: countryId),
           let cachedImage = UIImage(data: cachedData) {
            self.image = cachedImage
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let data = try await networkManager.getFlagImage(for: urlString)
            if let uiImage = UIImage(data: data) {
                imageCache.save(data: data, id: countryId)
                self.image = uiImage
            }
        } catch {
            self.image = UIImage(systemName: "flag.slash.fill")
        }
    }
}
