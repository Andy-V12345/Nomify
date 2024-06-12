//
//  NomifyApp.swift
//  Nomify
//
//  Created by Andy Vu on 6/11/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct NomifyApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            ViewManager()
        }
    }
}

struct ViewManager: View {
    
    @State private var authInfo: AuthInfo = AuthInfo()
    
    var body: some View {
        Group {
            if authInfo.state == .notAuthorized {
                AuthView()
                    .environment(authInfo)
            }
            else if authInfo.state == .authorized {
                HomeView()
            }
        }
    }
}
