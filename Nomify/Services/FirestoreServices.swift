//
//  FirestoreServices.swift
//  Nomify
//
//  Created by Andy Vu on 6/12/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserInfo: Codable {
    var allergenProfile: [String: String]
    var isConfigured: Bool
}

class FirestoreServices {
    private let db = Firestore.firestore()
    
    // MARK: getUserInfo(uid: String) -> UserInfo?
    func getUserInfo(uid: String) async -> UserInfo? {
        let docRef = db.collection("users").document(uid)
        do {
            let userInfo = try await docRef.getDocument(as: UserInfo.self)
            return userInfo
        }
        catch {
            return nil
        }
    }
    
    // MARK: writeUserInfo(uid: String, userInfo: UserInfo) -> Bool
    func writeUserInfo(uid: String, userInfo: UserInfo) -> Bool {
        do {
            try db.collection("users").document(uid).setData(from: userInfo)
            return true
        }
        catch {
            return false
        }
    }
    
    // MARK: deleteUserInfo(uid: String)
    func deleteUserInfo(uid: String) async throws {
        do {
            try await db.collection("users").document(uid).delete()
        }
        catch {
            throw error
        }
    }
}

