//
//  HomeView.swift
//  Nomify
//
//  Created by Andy Vu on 6/11/24.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    var body: some View {
        Button(action: {
            do {
                try Auth.auth().signOut()
            }
            catch {
                
            }
        }, label: {
            Text("Sign Out")
        })
    }
}

#Preview {
    HomeView()
}
