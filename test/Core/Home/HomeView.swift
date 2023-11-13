//
//  HomeTabView.swift
//  test
//
//  Created by Cem Dedetas on 22.09.2023.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var tabSelection:Int
    let tabBarItems = [("map","Map"),
                       ("bubble.left.and.bubble.right","Chat"),
                       ("rectangle.stack.badge.person.crop","My Ads"),
                       ("gearshape","Settings")]
    
    var body: some View {
        
        NavigationStack{
            TabView(selection: $tabSelection) {
                MapView().tag(1)
    //            AdsListView().tag(2)
                MyAdsView().tag(3)
                ProfileView().tag(4)
                MessagesView().tag(2)
            }
            .overlay(alignment:.bottom){
                        BottomNavTabComponent(tabSelection: $tabSelection ,tabBarItems:tabBarItems)
                        
                    }
        }
    }
}

#Preview{
    HomeView(tabSelection: .constant(1))
}
