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
    @State private var isViewingProfile = false
    
    @State var foodSearch = ""
    
    @Environment(AuthInfo.self) private var authInfo
    
    let firebaseServices = FirebaseServices()
    
    var body: some View {
        GeometryReader { metrics in
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Nomify")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            isViewingProfile = true
                        }, label: {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                        })
                    } //: Header HStack
                    .foregroundStyle(Color("themeGreen"))
                    
                    HStack(spacing: 25) {
                        SearchBar(text: $foodSearch, placeholder: "Search for a food")
                        
                        Image(systemName: "barcode.viewfinder")
                            .foregroundStyle(.black)
                            .font(.title)
                    }
                    
                    Spacer()
                } //: VStack
                .padding(.vertical, 20)
                .padding(.horizontal, 25)
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
                
                SideBar(isViewingProfile: $isViewingProfile, isConfiguring: $isConfiguring)
                
            } //: ZStack
            .onTapGesture {
                hideKeyboard()
            }
        }
        
    }
}
