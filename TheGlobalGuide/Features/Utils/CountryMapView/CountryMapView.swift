//
//  CountryMapView.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado on 17/12/25.
//

import SwiftUI
import MapKit

struct CountryMapView: View {
    
    let name: String
    let latlng: [Double]
    private var coordinate: CLLocationCoordinate2D {
        let lat = latlng.first ?? 0.0
        let long = latlng.last ?? 0.0
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
        
    
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $position) {
            Marker(name, coordinate: coordinate)
                .tint(.indigo)
        }
        .onAppear {
            updatePosition()
        }
        .onChange(of: latlng) { _, _ in
            updatePosition()
        }
    }
    
    private func updatePosition() {
        let span = MKCoordinateSpan(latitudeDelta: 15.0, longitudeDelta: 15.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        withAnimation {
            position = .region(region)
        }
    }
}

#Preview {
    CountryMapView(name: "Mexico", latlng: [23.6345, -102.5528])
}
