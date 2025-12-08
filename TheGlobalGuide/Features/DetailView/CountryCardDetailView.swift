//
//  CountryDetailView.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 05/12/25.
//

import SwiftUI

struct CountryCardDetailView: View {
    let country: Country
    @StateObject var viewModel = CountryDetailViewModel()
    @State private var showContent = false
    var animation: Namespace.ID
    var onClose: () -> Void
    
    
    var body: some View {
        
        VStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        
                        // Image
                        FlagImageView(countryId: country.id, urlString: country.flags.png)
                            .frame(width: 350, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black ,lineWidth: 3)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top)
                            .matchedGeometryEffect(id: "flag_\(country.id)", in: animation)
                            .transition(.hero)
                        
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
                    }
                    
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
                        .background(Color(UIColor.secondarySystemGroupedBackground))
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
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)
            }
            .background(Color(UIColor.secondarySystemGroupedBackground))
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
        .task(id: country.flags.png) {
            await viewModel.fetchImage(imageURL: country.flags.png)
            showContent = true
        }
        .matchedGeometryEffect(id: "container_\(country.id)", in: animation)
        .transition(.scale)
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

