//
//  AuthState.swift
//  Nomify
//
//  Created by Andy Vu on 6/11/24.
//

import Foundation
import FirebaseAuth
import SwiftUI

enum AuthState {
    case undefined, notAuthorized, authorized
}

@Observable
class AuthInfo {
    
    var state: AuthState = .undefined
    var user: User? = nil
    var userInfo: UserInfo? = nil
    
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            self.state = user != nil ? .authorized : .notAuthorized
            self.user = user
        }
    }
    
    @MainActor
    func logIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    @MainActor
    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    
    
}
