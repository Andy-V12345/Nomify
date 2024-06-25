//
//  LoadingSpinner.swift
//  Nomify
//
//  Created by Andy Vu on 6/16/24.
//

import SwiftUI

struct LoadingSpinner: View {
    
    @State var size: CGFloat
    @State var spinnerLength = 0.6
    @State var degree = 270
    
    var body: some View {
        Circle()
            .trim(from: 0, to: spinnerLength)
            .stroke(Color("themeGreen"), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            .animation(.easeIn(duration: 1.5).repeatForever(autoreverses: true), value: spinnerLength)
            .frame(width: size, height: size)
            .rotationEffect(Angle(degrees: Double(degree)))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: degree)
            .onAppear {
                degree = 270 + 360
                spinnerLength = 0
            }
    }
}
