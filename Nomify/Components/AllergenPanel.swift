//
//  AllergenPanel.swift
//  Nomify
//
//  Created by Andy Vu on 6/12/24.
//

import SwiftUI

enum Severity: String, CaseIterable, Identifiable {
    case none, mild, moderate, severe
    var id: Self { self }
}

struct AllergenPanel: View {
    
    @Binding var allergenProfile: [String: String]
    @State var allergen: String
    @State var sev: String
    @State var sevColor: Color = .green
    
    @State var selectedSev: Severity = .none
    
    var body: some View {
        DisclosureGroup(content: {
            Picker("Severity", selection: $selectedSev) {
                ForEach(Severity.allCases) { severity in
                    Text(severity.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            .preferredColorScheme(.light)
            .padding(.top)
            
        }, label: {
            HStack {
                Text(allergen)
                    .bold()
                    .font(.title3)
                    .foregroundStyle(.black)
                
                Spacer()
                
                Text(sev)
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .foregroundStyle(sevColor)
            }
            .padding(.trailing, 10)
        }) //: DisclosureGroup
        .tint(Color("darkGreen"))
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .background(RoundedRectangle(cornerRadius: 15).fill(.white))
        .onChange(of: selectedSev) { old, new in
            if new == .none {
                sev = "Not Allergic"
                sevColor = .green
            }
            else if new == .mild {
                sev = "Mildly Allergic"
                sevColor = .yellow
            }
            else if new == .moderate {
                sev = "Moderately Allergic"
                sevColor = .orange
            }
            else if new == .severe {
                sev = "Severely Allergic"
                sevColor = .red
            }
            allergenProfile[allergen] = sev
        }
        .onAppear {
            if sev == "Not Allergic" {
                sevColor = .green
                selectedSev = .none
            }
            else if sev == "Mildly Allergic" {
                sevColor = .yellow
                selectedSev = .mild
            }
            else if sev == "Moderately Allergic" {
                sevColor = .orange
                selectedSev = .moderate
            }
            else if sev == "Severely Allergic" {
                sevColor = .red
                selectedSev = .severe
            }
        }
    }
}
