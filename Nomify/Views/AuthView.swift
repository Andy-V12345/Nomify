//
//  AuthView.swift
//  Nomify
//
//  Created by Andy Vu on 6/11/24.
//

import SwiftUI

struct AuthView: View {
    
    @State var email = ""
    @State var password = ""
    @State var confirmedPassword = ""
    
    @State var isLogIn = true
    
    func toggleState() {
        isLogIn.toggle()
        email = ""
        password = ""
        confirmedPassword = ""
        hideKeyboard()
    }
    
    var body: some View {
        GeometryReader { metrics in
            ZStack {
                Color(.white)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 30) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Welcome to")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title3)
                        Text("Nomify")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Please sign in to get started!")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.subheadline)
                    } //: Header VStack
                    .foregroundStyle(Color("themeGreen"))
                    .fontWeight(.bold)
                    
                    ZStack {
                        if isLogIn {
                            LogIn
                        }
                        else {
                            SignUp
                        }
                    }
                    
                    Spacer()
                } //: VStack
                .padding(.vertical, 20)
                .padding(.horizontal, 25)
                
            } //: ZStack
            .onTapGesture {
                hideKeyboard()
            }
        } //: GeometryReader
    } //: Body
    
    var LogIn: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Image(systemName: "envelope")
                    .foregroundStyle(.gray)
                CustomTextField(placeholder: Text("Email").foregroundStyle(.gray), text: $email, isSecure: false)
                    .frame(height: 50)
            } //: Email HStack
            .overlay(
                Divider()
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .background(Color("themeGreen")),
                alignment: .bottom
            )
            
            HStack(spacing: 20) {
                Image(systemName: "lock")
                    .foregroundStyle(.gray)
                CustomTextField(placeholder: Text("Password").foregroundStyle(.gray), text: $password, isSecure: true)
                    .frame(height: 50)
            } //: Password HStack
            .overlay(
                Divider()
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .background(Color("themeGreen")),
                alignment: .bottom
            )
            
            HStack {
                Button(action: {
                    // TODO: FORGOT PASSWORD FEATURE
                }, label: {
                    Text("Forgot password?")
                        .italic()
                        .foregroundStyle(Color("themeGreen"))
                        .font(.subheadline)
                })
                
                Spacer()
            } //: ForgotPassword HStack
            
            Button(action: {
                // TODO: LOG IN FEATURE
            }, label: {
                Text("Log In")
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("themeGreen")))
                    .clipped()
                    .shadow(radius: 2, y: 4)
            }) //: Log In Button
            
            HStack {
                Spacer()
                
                Text("Don't have an account?")
                    .foregroundStyle(Color.black)
                    .italic()
                Button(action: {
                    toggleState()
                }, label: {
                    Text("Create one")
                        .foregroundStyle(Color("themeGreen"))
                        .italic()
                })
                
                Spacer()
            } //: Switch to Sign Up HStack
            .font(.subheadline)
            
            Text("or")
                .foregroundStyle(Color("themeGreen"))
                .italic()
                .font(.subheadline)
            
            Button(action: {
                // TODO: SIGN IN WITH GOOGLE FEATURE
            }, label: {
                HStack(spacing: 8) {
                    Text("Sign in with Google")
                        .foregroundStyle(Color("themeGreen"))
                        .bold()
                    Image("google")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .clipped()
                .shadow(radius: 2)
            })
            
        } //: Auth VStack
    } //: LogIn View
    
    var SignUp: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Image(systemName: "envelope")
                    .foregroundStyle(.gray)
                CustomTextField(placeholder: Text("Email").foregroundStyle(.gray), text: $email, isSecure: false)
                    .frame(height: 50)
            } //: Email HStack
            .overlay(
                Divider()
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .background(Color("themeGreen")),
                alignment: .bottom
            )
            
            HStack(spacing: 20) {
                Image(systemName: "lock")
                    .foregroundStyle(.gray)
                CustomTextField(placeholder: Text("Password").foregroundStyle(.gray), text: $password, isSecure: true)
                    .frame(height: 50)
            } //: Password HStack
            .overlay(
                Divider()
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .background(Color("themeGreen")),
                alignment: .bottom
            )
            
            HStack(spacing: 20) {
                Image(systemName: "lock")
                    .foregroundStyle(.gray)
                CustomTextField(placeholder: Text("Confirm password").foregroundStyle(.gray), text: $confirmedPassword, isSecure: true)
                    .frame(height: 50)
            } //: Password HStack
            .overlay(
                Divider()
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .background(Color("themeGreen")),
                alignment: .bottom
            )
            
            Button(action: {
                // TODO: SIGN UP FEATURE
            }, label: {
                Text("Sign Up")
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("themeGreen")))
                    .clipped()
                    .shadow(radius: 2, y: 4)
            }) //: Log In Button
            
            HStack {
                Spacer()
                
                Text("Have an account?")
                    .foregroundStyle(Color.black)
                    .italic()
                Button(action: {
                    toggleState()
                }, label: {
                    Text("Log in")
                        .foregroundStyle(Color("themeGreen"))
                        .italic()
                })
                
                Spacer()
            } //: Switch to Log In HStack
            .font(.subheadline)
            
            Text("or")
                .foregroundStyle(Color("themeGreen"))
                .italic()
                .font(.subheadline)
            
            Button(action: {
                // TODO: SIGN IN WITH GOOGLE FEATURE
            }, label: {
                HStack(spacing: 8) {
                    Text("Sign in with Google")
                        .foregroundStyle(Color("themeGreen"))
                        .bold()
                    Image("google")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .clipped()
                .shadow(radius: 2)
            })
            
        } //: Auth VStack
        
    } //: SignUp View
}

#Preview {
    AuthView()
}
