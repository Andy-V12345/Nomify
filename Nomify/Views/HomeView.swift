//
//  HomeView.swift
//  Nomify
//
//  Created by Andy Vu on 6/11/24.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @State var isConfiguring = false
    
    @Environment(AuthInfo.self) private var authInfo
    
    let firebaseServices = FirebaseServices()
    
    var body: some View {
                
        ZStack {
            
            Color.white.ignoresSafeArea()
            
            VStack {
                Button(action: {
                    do {
                        try Auth.auth().signOut()
                    }
                    catch {
                        
                    }
                }, label: {
                    Text("Sign Out")
                })
            } //: VStack
            .onAppear {
                Task {
                    let userInfo = await firebaseServices.getUserInfo(uid: authInfo.user!.uid)
                    
                    authInfo.userInfo = userInfo
                    
                    if userInfo == nil || !userInfo!.isConfigured {
                        isConfiguring = true
                    }
                }
            }
            .fullScreenCover(isPresented: $isConfiguring, content: {
                AllergenProfileView(allergenProfile: authInfo.userInfo?.allergenProfile)
            })
        } //: ZStack
        
    }
}
