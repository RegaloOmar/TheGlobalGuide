//
//  Transitions.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 07/12/25.
//

import SwiftUI

extension AnyTransition {
    
    static let hero = AnyTransition.modifier(active: HeroModifier(percentage: 1), identity: HeroModifier(percentage: 0))
    
    struct HeroModifier: AnimatableModifier {
        
        var percentage: Double
        
        var animatableData: Double {
            get {
                percentage
            }
            
            set {
                percentage = newValue
            }
        }
        
        func body(content: Content ) -> some View {
            content
                .opacity(1)
        }
    }
}
