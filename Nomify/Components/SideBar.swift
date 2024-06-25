//
//  SideBar.swift
//  Nomify
//
//  Created by Andy Vu on 6/13/24.
//

import SwiftUI
import FirebaseAuth

struct SideBar: View {
    
    @Binding var isViewingProfile: Bool
    @Environment(AuthInfo.self) var authInfo
    @Binding var isConfiguring: Bool
    
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.7
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(.black.opacity(0.6))
            .opacity(isViewingProfile ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: isViewingProfile)
            .onTapGesture {
                isViewingProfile.toggle()
            }
            
            HStack(alignment: .top) {
                ZStack(alignment: .top) {
                    Color("themeGreen")
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color("themeGreen"))
                            .frame(width: 60, height: 60)
                            .rotationEffect(Angle(degrees: 45))
                            .offset(x: isViewingProfile ? -18 : -40)
                            .onTapGesture {
                                isViewingProfile.toggle()
                            }
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .rotationEffect(Angle(degrees: 180))
                            .offset(x: isViewingProfile ? -4 : -30)
                    }
                    .offset(x: sideBarWidth / 2, y: 80)
                    .animation(.default, value: isViewingProfile)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        VStack {
                            Text("Your Profile")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                                .font(.title)
                            Text(authInfo.user?.email ?? "")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fontWeight(.semibold)
                        } //: Text VStack
                        
                        Divider()
                            .overlay(.white)
                        
                        VStack(spacing: 20) {
                            Button(action: {
                                isConfiguring = true
                            }, label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "slider.horizontal.2.square")
                                        .font(.title3)
                                    
                                    Text("Change allergen profile")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            })
                            
                            Button(action: {
                                do {
                                    try Auth.auth().signOut()
                                }
                                catch {
                                    print("Error logging out")
                                }
                            }, label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "figure.walk.departure")
                                        .font(.title3)
                                    
                                    Text("Sign out")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            })
                            
                        } //: Button VStack
                        .foregroundStyle(.white)
                        .font(.headline)
                        .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            // TODO: DELETE ACCOUNT BUTTON
                        }, label: {
                            Text("Delete Account")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                                .padding()
                                .foregroundStyle(.red)
                                .background(RoundedRectangle(cornerRadius: 15).fill(.white))
                            
                        })
                        
                        
                    } //: VStack
                    .padding(.top, 80)
                    .padding(.bottom, 40)
                    .padding(.horizontal, 25)
                    .foregroundStyle(.white)
                }
                .frame(width: sideBarWidth)
                .offset(x: isViewingProfile ? 0 : -sideBarWidth)
                .animation(.default, value: isViewingProfile)
                
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .all)
        
    }
}
