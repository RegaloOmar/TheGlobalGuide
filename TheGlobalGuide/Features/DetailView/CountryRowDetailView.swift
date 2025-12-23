//
//  CountryRowDetailView.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 06/12/25.
//

import SwiftUI

struct CountryRowDetailView: View {
    let country: Country
    @ObservedObject var favoriteViewModel: CountryListViewModel
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    
                    //MARK: - Image
                    FlagImageView(countryId: country.id, urlString: country.flags.png)
                        .frame(width: 350, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black ,lineWidth: 3)
                        }
                        .padding(.horizontal)
                    
                    VStack(spacing: 4) {
                        Text(country.commonName)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        Text(country.officialName)
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                }
                
                //MARK: - What you need to know section
                VStack(alignment: .leading, spacing: 16) {
                    Text("What you need to know")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        DetailRow(icon: "banknote", title: "Currency", value: country.currencyList)
                        Divider().padding(.leading, 44)
                        DetailRow(icon: "message", title: "Languages", value: country.languageList)
                        Divider().padding(.leading, 44)
                        DetailRow(icon: "clock", title: "Time Zone", value: country.timezones.first ?? "N/A")
                    }
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                //MARK: - Geographic Information
                VStack(alignment: .leading, spacing: 16) {
                    Text("Geographic Information")
                        .font(.title3)
                        .bold()
                        .padding(.horizontal)
                    
                    VStack {
                        DetailRow(icon: "building.columns", title: "Capital", value: country.capitalName)
                        Divider().padding(.leading, 44)
                        DetailRow(icon: "map", title: "Region", value: country.region)
                        Divider().padding(.leading, 44)
                        DetailRow(icon: "person.3", title: "Population", value: country.populationFormatted)
                    }
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                //MARK: - MapView
                VStack(alignment: .leading) {
                    
                    Text("Location")
                        .font(.title3)
                        .bold()
                        .padding(.horizontal)
                    
                    if !country.latlng.isEmpty {
                        
                        CountryMapView(name: country.commonName, latlng: country.latlng)
                            .frame(height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 2)
                                    .padding(.horizontal)
                            }
                    } else {
                        Text("Location data not available")
                            .italic()
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        favoriteViewModel.toggleFavorite(country)
                    }
                } label: {
                    Image(systemName: favoriteViewModel.isFavorite(country) ? "heart.fill" : "heart")
                        .foregroundStyle(favoriteViewModel.isFavorite(country) ? .red : .indigo)
                        .font(.title3)
                }
            }
        }
    }
}

