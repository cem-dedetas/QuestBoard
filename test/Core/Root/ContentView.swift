//
//  ContentView.swift
//  test
//
//  Created by Cem Dedetas on 4.09.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel:AuthViewModel
    @State var tabSelection = 1
    var body: some View {
        Group{
//            if(authViewModel.userSession != nil) {
//                MapView()
//            }
//            else {
//                LoginView()
//            }
            HomeView(tabSelection: $tabSelection)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthViewModel())
    }
}
