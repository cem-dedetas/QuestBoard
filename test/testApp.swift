//
//  testApp.swift
//  test
//
//  Created by Cem Dedetas on 4.09.2023.
//

import SwiftUI


@main
struct testApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var mapViewModel = MapViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authViewModel).environmentObject(mapViewModel)
        }
    }
}
