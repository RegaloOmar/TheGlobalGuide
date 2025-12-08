//
//  CountryRowView.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 05/12/25.
//

import SwiftUI

struct CountryRowView: View {
    
    let country: Country
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            
            FlagImageView(countryId: country.id, urlString: country.flags.png)
                .clipShape(Circle())
                .frame(width: 100, height: 100, alignment: .center)
                .overlay {
                    Circle().stroke(Color.black ,lineWidth: 2)
                }
            
            VStack(alignment: .leading, spacing: 40) {
                Text(country.commonName)
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                
                Text(country.region)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
            }
            
            Spacer()
            
            Button(action: onFavoriteToggle) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(isFavorite ? Color.red : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
        .frame(height: 120, alignment: .center)
    }
}
