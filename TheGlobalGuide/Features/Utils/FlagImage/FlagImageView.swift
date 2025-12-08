//
//  FlagView.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 06/12/25.
//

import SwiftUI

struct FlagImageView: View {
    
    let countryId: String
    let urlString: String
    @StateObject private var viewModel = FlagImageViewModel()
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.1)
            
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            } else {
                Image(systemName: "flag.slash")
                    .foregroundColor(.gray)
            }
        }
        .task(id: urlString) {
            await viewModel.loadImage(from: urlString, countryId: countryId)
        }
    }
}

#Preview {
    FlagImageView(countryId: "MEX", urlString: "https://flagcdn.com/w320/mx.png")
            .frame(width: 100, height: 60)
}
