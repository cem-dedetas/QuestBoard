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
//            AdsListView().tag(2)
            MyAdsView().tag(3)
            ProfileView().tag(4)
            MessagesView().tag(2)
        }
        
    }
}

#Preview{
    HomeView(tabSelection: .constant(1))
}
