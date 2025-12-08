//
//  LoaderView.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 07/12/25.
//

import SwiftUI

struct LoaderView: View {

    let globes = ["globe.americas.fill",
                  "globe.europe.africa.fill",
                  "globe.asia.australia.fill",
                  "globe.central.south.asia.fill"]
    
    
    @State private var currentIndex = 0
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: globes[currentIndex])
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                    .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                
                Text("Get ready to explore....")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
        }
        .task {
            while true {
                try? await Task.sleep(for: .seconds(1.0))
                
                
                withAnimation(.easeInOut(duration: 0.5)) {
                    rotation = 90
                }
                
                try? await Task.sleep(for: .seconds(0.5))
                
                currentIndex = (currentIndex + 1) % globes.count
                rotation = -90
                
                withAnimation(.easeInOut(duration: 0.5)) {
                    rotation = 0
                }
            }
        }
    }
}

#Preview {
    LoaderView()
}
