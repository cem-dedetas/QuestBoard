//
//  testApp.swift
//  test
//
//  Created by Cem Dedetas on 4.09.2023.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct testApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var mapViewModel = MapViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authViewModel).environmentObject(mapViewModel)
        }
    }
}
