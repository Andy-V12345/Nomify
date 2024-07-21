//
//  AllergenProfileView.swift
//  Nomify
//
//  Created by Andy Vu on 6/12/24.
//

import SwiftUI

struct AllergenProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(AuthInfo.self) private var authInfo
    
    @State var showAlert = false
    
    @State var allergenProfile: [String: String]
    
    @State var allergens: [String] = ["Dairy", "Eggs", "Fish", "Shellfish", "Tree Nuts", "Peanuts", "Wheat", "Soybeans", "Sesame"]
    
    let firestoreServices = FirestoreServices()
    
    init(allergenProfile: [String: String]?) {
        if allergenProfile == nil {
            self.allergenProfile = [
                "Dairy" : "Not Allergic",
                "Eggs" : "Not Allergic",
                "Fish" : "Not Allergic",
                "Shellfish" : "Not Allergic",
                "Tree Nuts" : "Not Allergic",
                "Peanuts" : "Not Allergic",
                "Wheat" : "Not Allergic",
                "Soybeans" : "Not Allergic",
                "Sesame" : "Not Allergic"
            ]
        }
        else {
            self.allergenProfile = allergenProfile!
        }
    }
    
    
    var body: some View {
        GeometryReader { metrics in
            ZStack {
                Color("themeGreen").ignoresSafeArea()
                
                VStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            VStack(spacing: 5) {
                                Text("Customize Your")
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Allergen Profile")
                                    .font(.largeTitle)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if authInfo.state == .guest {
                                    showAlert = true
                                }
                                else {
                                    let newUserInfo = UserInfo(allergenProfile: allergenProfile, isConfigured: true)
                                    let success = firestoreServices.writeUserInfo(uid: authInfo.user!.uid, userInfo: newUserInfo)
                                    if success {
                                        authInfo.userInfo = newUserInfo
                                        dismiss()
                                    }
                                    else {
                                        print("Error saving user info")
                                    }
                                }
                            }, label: {
                                Text("Save")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color("themeGreen"))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 5)
                                    .background(RoundedRectangle(cornerRadius: 15).fill(.white))
                                    .clipped()
                                    .shadow(radius: 2, y: 4)
                            }) //: Done Button
                        } //: HStack
                        
                        Text("Don't worry! We only use it to help you make informed food choices. Plus, you can make changes later!")
                            .frame(maxWidth: metrics.size.width * 0.77, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .font(.subheadline)
                    } //: Header VStack
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(allergens, id: \.self) { allergen in
                                AllergenPanel(allergenProfile: $allergenProfile, allergen: allergen, sev: allergenProfile[allergen]!)
                            }
                        } //: List VStack
                    } //: ScrollView
                    .scrollIndicators(.hidden)
                    
                } //: VStack
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                
            } //: ZStack
            .alert("Heads Up", isPresented: $showAlert, actions: {
                Button(role: .none, action: {
                    let newUserInfo = UserInfo(allergenProfile: allergenProfile, isConfigured: true)
                    authInfo.userInfo = newUserInfo
                    dismiss()
                }, label: {
                    Text("Save")
                })
                
                Button(role: .none, action: {
                    authInfo.state = .notAuthorized
                }, label: {
                    Text("Sign in")
                })
            }, message: {
                Text("Since you are not signed in, your allergen profile will not be saved after you close Nomify. Sign in or create an account to keep your allergen profile saved.")
            })
        } //: GeometryReader
    }
}
