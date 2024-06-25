//
//  AllergenRiskRating.swift
//  Nomify
//
//  Created by Andy Vu on 6/15/24.
//

import SwiftUI

struct AllergenRiskRating: View {
    
    @State var allergen: String
    @State var riskRating: Double
    
    @State var uiRiskRating: Double = 0
    
    var body: some View {
        VStack(spacing: 10) {
            
            HStack {
                Text(allergen)
                
                Spacer()
                
                Text("\(Int(riskRating))%")
            }
            .foregroundStyle(.black)
            .bold()
            
            Rectangle()
                .foregroundStyle(Color.gray.opacity(0.1))
                .frame(height: 4)
                .overlay(
                    GeometryReader { metrics in
                        Rectangle()
                            .foregroundStyle(uiRiskRating <= 25 ? Color("themeGreen") : uiRiskRating > 25 && uiRiskRating <= 50 ? Color.yellow : uiRiskRating > 50 && uiRiskRating <= 75 ? Color.orange : Color.red)
                            .frame(width: (uiRiskRating / 100) * metrics.size.width, height: 4)
                    }
                )
        
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            withAnimation(.linear(duration: 0.85)) {
                uiRiskRating = riskRating
            }
        }
    }
}

