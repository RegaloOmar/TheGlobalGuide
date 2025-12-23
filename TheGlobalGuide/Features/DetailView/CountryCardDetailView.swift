//
//  CountryDetailView.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 05/12/25.
//

import SwiftUI

struct CountryCardDetailView: View {
    let country: Country
    @State private var showContent = false
    var animation: Namespace.ID
    var onClose: () -> Void
    
    
    var body: some View {
        
        VStack {
            ScrollView {
                VStack(spacing: 24) {
                    //MARK: - Image & Name
                    FlagImageView(countryId: country.id, urlString: country.flags.png)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .matchedGeometryEffect(id: "flag_\(country.id)", in: animation)
                        .padding(.bottom, 20)
                    
                    VStack(spacing: 4) {
                        Text(country.commonName)
                            .font(.largeTitle)
                            .bold()
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .multilineTextAlignment(.center)
                        
                        Text(country.officialName)
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    
                    //MARK: - What you need to know section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("What you need to know")
                            .font(.title2)
                            .bold()
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            DetailRow(icon: "banknote", title: "Currency", value: country.currencyList)
                            Divider().padding(.leading, 44)
                            DetailRow(icon: "message", title: "Languages", value: country.languageList)
                            Divider().padding(.leading, 44)
                            DetailRow(icon: "clock", title: "Time Zone", value: country.timezones.first ?? "N/A")
                        }
                        .cornerRadius(12)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .padding(.horizontal)
                    }
                    
                    //MARK: - Geographic Information
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Geographic Information")
                            .font(.title3)
                            .bold()
                            .opacity(showContent ? 1 : 0)
                            .padding(.horizontal)
                        
                        VStack {
                            DetailRow(icon: "building.columns", title: "Capital", value: country.capitalName)
                            Divider().padding(.leading, 44)
                            DetailRow(icon: "map", title: "Region", value: country.region)
                            Divider().padding(.leading, 44)
                            DetailRow(icon: "person.3", title: "Population", value: country.populationFormatted)
                        }
                        .cornerRadius(12)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .padding(.horizontal)
                    }
                    
                    //MARK: - MapView
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Location")
                            .font(.title3)
                            .bold()
                        
                        if !country.latlng.isEmpty {
                            
                            CountryMapView(name: country.commonName, latlng: country.latlng)
                                .frame(height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.indigo, lineWidth: 2)
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
                    .cornerRadius(12)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
            .background(Color(UIColor.secondarySystemBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    GlassEffectContainer {
                        Button(action: onClose) {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .foregroundStyle(Color.indigo)
                                .opacity(showContent ? 1 : 0)
                        }
                    }
                    
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3).delay(0.2)) {
                showContent = true
            }
        }
    }
}


struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(.indigo)
            
            Text(title)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
        .padding()
    }
}

