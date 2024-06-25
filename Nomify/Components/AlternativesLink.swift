//
//  AlternativesLink.swift
//  Nomify
//
//  Created by Andy Vu on 6/15/24.
//

import SwiftUI

struct AlternativesLink: View {
    
    @State var name: String
    @State var url: String
    
    var body: some View {
        HStack {
            VStack(spacing: 6) {
                Text(name)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Link(destination: URL(string: url)!, label: {
                    HStack {
                        Text("Learn more here")
                        
                        Image(systemName: "link")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color("darkGreen"))
            }
            
            Spacer()
            
            Button(action: {
                // TODO: SAVE RECIPE / BRAND BUTTON
            }, label: {
                Image(systemName: "square.and.arrow.down")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("themeGreen"))
            })
        }
    }
}

