//
//  ForgotPasswordView.swift
//  Nomify
//
//  Created by Andy Vu on 7/6/24.
//

import SwiftUI
import AlertToast
import FirebaseAuth

struct ForgotPasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var email = ""
    @State var errorMsg = ""
    @State var isError = false
    @State var isSuccess = false
    
    @FocusState var isEmailFocused: Bool
    
    func validateEmail(email: String) -> Bool {
        if email.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .foregroundStyle(Color("themeGreen"))
                        .font(.title2)
                        .onTapGesture {
                            dismiss()
                        }
                }
                
                Spacer()
            }
            .padding(20)
            
            VStack {
                
                VStack(spacing: 40) {
                    VStack(spacing: 20) {
                        Text("Forgot Password")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)
                        Text("Enter your email and we'll send you a link to reset your password")
                            .foregroundColor(.black)
                            .frame(width: 300)
                            .multilineTextAlignment(.center)
                        
                        // MARK: Email textfield
                        
                        HStack(spacing: 20) {
                            Image(systemName: "envelope")
                                .foregroundStyle(Color("themeGreen"))
                            CustomTextField(placeholder: Text("Email").foregroundColor(.gray), text: $email, isSecure: false)
                                .frame(height: 50)
                                .focused($isEmailFocused)
                            
                        }
                        .overlay(
                            Divider()
                                .padding(.vertical, 0)
                                .frame(maxWidth: .infinity, maxHeight:1)
                                .background(Color("themeGreen")), alignment: .bottom
                        )
                        
                    }
                    
                    Button(action: {
                        // MARK: send link
                        if validateEmail(email: email) {
                            Auth.auth().sendPasswordReset(withEmail: email) { error in
                                if error != nil {
                                    errorMsg = "Invalid email"
                                    isError = true
                                }
                                else {
                                    isSuccess = true
                                    isEmailFocused = false
                                }
                            }
                        }
                        else {
                            errorMsg = "Invalid email"
                            isError = true
                        }
                    }, label: {
                        Text("Send Link")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color("themeGreen"))
                            .cornerRadius(10)
                    })
                    
                }
                
                
                Spacer()
                
                
            }
            .padding(.horizontal, 40)
            .padding(.top, 100)
        }
        .onTapGesture {
            isEmailFocused = false
        }
        .edgesIgnoringSafeArea([.bottom, .trailing, .leading])
        .toast(isPresenting: $isSuccess, duration: 1.5, alert: {
            AlertToast(displayMode: .alert, type: .complete(.green), title: "Link Sent!")
        }, completion: {
            email = ""
            dismiss()
        })
        .toast(isPresenting: $isError, duration: 1, alert: {
            AlertToast(displayMode: .alert, type: .error(.red), subTitle: errorMsg)
        })
    }
}

#Preview {
    ForgotPasswordView()
}
