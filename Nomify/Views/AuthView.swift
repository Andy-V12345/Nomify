//
//  AuthView.swift
//  Nomify
//
//  Created by Andy Vu on 6/11/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import AlertToast
import GoogleSignIn

struct AuthView: View {
    
    @Environment(AuthInfo.self) private var authInfo
    
    @State var email = ""
    @State var password = ""
    @State var confirmedPassword = ""
    @State var isError = false
    @State var errorMsg = ""
    @State var isLogIn = true
    @State var isLoading = false
    
    
    func toggleState() {
        isLogIn.toggle()
        email = ""
        password = ""
        confirmedPassword = ""
        hideKeyboard()
    }
    
    func googleLogIn() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        isLoading = true
                
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
            guard error == nil else {
                isLoading = false
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                errorMsg = "Something went wrong! Please try again."
                isError = true
                isLoading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            
            Auth.auth().signIn(with: credential)
            
            if authInfo.state == .authorized {
                isLoading = false
            }
        }
    }
    
    var body: some View {
        GeometryReader { metrics in
            ZStack {
                Color(.white)
                    .ignoresSafeArea(.all)
                
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .tint(Color("themeGreen"))
                            .frame(width: 300)
                            .controlSize(.large)
                        Spacer()
                    }
                }
                
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
                .toast(isPresenting: $isError, duration: 3, alert: {
                    AlertToast(displayMode: .hud, type: .error(Color.red), subTitle: errorMsg)
                })
                .disabled(isLoading)
                .clipped()
                .opacity(isLoading ? 0.3 : 1)
                
                
            } //: ZStack
            .onTapGesture {
                hideKeyboard()
                isError = false
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
                hideKeyboard()
                Task {
                    do {
                        isLoading = true
                        try await authInfo.logIn(email: email, password: password)
                        isLoading = false
                    }
                    catch {
                        isLoading = false
                        
                        let e = error as NSError
                        
                        let code = AuthErrorCode.Code(rawValue: e.code)
                        
                        if code == .invalidEmail {
                            errorMsg = "Invalid email"
                        }
                        else if code == .wrongPassword {
                            errorMsg = "Incorrect email/password"
                        }
                        else if code == .invalidCredential {
                            errorMsg = "Incorrect email/password"
                        }
                        else {
                            errorMsg = "Something went wrong! Please try again."
                        }
                        
                        isError = true
                    }
                }
            }, label: {
                Text("Log In")
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("themeGreen")))
                    .opacity(email != "" && password != "" ? 1 : 0.6)
                    .clipped()
                    .shadow(radius: email != "" && password != "" ? 2 : 0, y: email != "" && password != "" ? 4 : 0)
                
            }) //: Log In Button
            .disabled(!(email != "" && password != ""))
            
            HStack {
                Spacer()
                
                Text("Don't have an account?")
                    .foregroundStyle(Color.black)
                    .italic()
                Button(action: {
                    withAnimation(.spring(dampingFraction: 0.7)) {
                        toggleState()
                    }
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
                googleLogIn()
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
                hideKeyboard()
                Task {
                    do {
                        isLoading = true
                        try await authInfo.signUp(email: email, password: password)
                        isLoading = false
                    }
                    catch {
                        isLoading = false
                        
                        let e = error as NSError
                        
                        let code = AuthErrorCode.Code(rawValue: e.code)
                        
                        if code == .weakPassword {
                            errorMsg = "Password needs to be 6+ characters"
                        }
                        else if code == .invalidEmail {
                            errorMsg = "Invalid Email"
                        }
                        else if code == .emailAlreadyInUse {
                            errorMsg = "Email already in use"
                        }
                        else {
                            errorMsg = "Something went wrong! Please try again."
                        }
                        
                        
                        isError = true
                    }
                }
            }, label: {
                Text("Sign Up")
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("themeGreen")))
                    .opacity(email != "" && password != "" && password == confirmedPassword ? 1 : 0.6)
                    .clipped()
                    .shadow(radius: email != "" && password != "" && password == confirmedPassword ? 2 : 0, y: email != "" && password != "" && password == confirmedPassword ? 4 : 0)
                
                
            }) //: Log In Button
            .disabled(!(email != "" && password != "" && password == confirmedPassword))
            
            HStack {
                Spacer()
                
                Text("Have an account?")
                    .foregroundStyle(Color.black)
                    .italic()
                Button(action: {
                    withAnimation(.spring(dampingFraction: 0.7)) {
                        toggleState()
                    }
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
                googleLogIn()
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

