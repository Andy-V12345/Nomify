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
    case undefined, notAuthorized, authorized, guest
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
    
    @MainActor
    func deleteAccount(password: String) async throws {
        let firestore = FirestoreServices()
        
        let uid = self.user!.uid
        let creds = EmailAuthProvider.credential(withEmail: self.user!.email ?? "", password: password)
        
        do {
            let _ = try await self.user?.reauthenticate(with: creds)
            
            try await firestore.deleteUserInfo(uid: uid)
            
            try await self.user?.delete()
        }
        catch {
            throw error
        }
    }
    
    
    
}
