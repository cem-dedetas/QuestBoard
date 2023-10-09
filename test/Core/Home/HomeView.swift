//
//  HomeTabView.swift
//  test
//
//  Created by Cem Dedetas on 22.09.2023.
//

import SwiftUI

struct HomeView: View {
    @Binding var tabSelection:Int
    var body: some View {
        TabView(selection: $tabSelection) {
            MapView().tag(1)
            Text("Tab Content 2").tag(2)
            MyAdsView().tag(3)
            Text("Tab Content 4").tag(4)
        }
        .overlay(alignment:.bottom){
            BottomNavTabComponent(tabSelection: $tabSelection ,tabBarItems:[("map","Map"),
                                                                           ("list.bullet.indent","List"),
                                                                           ("rectangle.stack.badge.person.crop","My Ads"),
                                                                           ("person","Profile")])
            
        }
    }
}

#Preview{
    HomeView(tabSelection: .constant(1))
}
