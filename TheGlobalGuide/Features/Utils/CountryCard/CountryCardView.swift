//
//  CountryCardView.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 05/12/25.
//

import SwiftUI
import UIKit

struct CountryCardView: View {
    let country: Country
    var animation: Namespace.ID
    var isSource: Bool
    let onRemove: () -> Void
    
    var body: some View {
        VStack {
            //Image
            FlagImageView(countryId: country.id, urlString: country.flags.png)
                .frame(width: 120, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black ,lineWidth: 3)
                }
                .matchedGeometryEffect(id: "flag_\(country.id)", in: animation, isSource: isSource)
                .padding(.horizontal, 20)
                .padding(.top)
            
            
            //Info
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    Text(country.commonName)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Button(action: onRemove) {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                    }
                }
                
                Text(country.region)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            
        }
        .toolbar(.hidden, for: .tabBar)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)        
    }
}

