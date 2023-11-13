//
//  AdsListView.swift
//  test
//
//  Created by Cem Dedetas on 16.10.2023.
//

import SwiftUI
import Sliders

struct AdsListView: View {
    @StateObject var advertsViewModel = MultiAdvertViewModel()
    @EnvironmentObject var mapViewModel:MapViewModel
    @EnvironmentObject var authViewModel:AuthViewModel
    @State var isFilterParamsSheetVisible:Bool = false
    @State var searchText:String = ""
    @State var pricelowValue = 0.0
    @State var pricehighValue = 10.0
    @State var distance = 0
    @State var isEditing = false
    
    var body: some View {
            VStack{
                if (advertsViewModel.isLoading || authViewModel.isLoading) {
                    ProgressView("Fetching Ads")
                } else {
                    GeometryReader{ proxy in
                        VStack(alignment: .center) {
                            ScrollView(.vertical){
                                ForEach(advertsViewModel.listings, id:\._id){ listing in
                                    NavigationLink{
                                        AdDetailsView(advert:listing)
                                    } label :{
                                        VStack {
                                            CachedImageView(url: listing.imgURLs.isEmpty ? "" : listing.imgURLs[0], width: proxy.size.width)
                                                
                                                .background(.regularMaterial)
                                                .overlay(alignment:.bottomTrailing){
                                                    HStack{
                                                        EstimatedTimeView(from: listing.location2d)
                                                        Image(systemName: "figure.walk")
                                                    }
                                                        .padding().background(.regularMaterial)
                                                        .clipShape(
                                                            .rect(
                                                                topLeadingRadius: 10,
                                                                bottomLeadingRadius: 10,
                                                                bottomTrailingRadius: 0,
                                                                topTrailingRadius: 0
                                                            )
                                                        )
                                                        .padding(.bottom)
                                                }
                                            HStack{
                                                VStack(alignment:.leading){
                                                    Text(listing.title).font(.title2)
                                                    if let address = listing.address{
                                                        Text("\(address.city) - \(address.town)").font(.footnote)
                                                    }
                                                }
                                                Spacer()
                                                if let user = authViewModel.currentUser {
                                                    LikeButtonComponent(adId:listing._id ,isFavorited: user.favorites.contains(where: { element in
                                                        element == listing._id
                                                    }))
                                                }
                                            }.padding()
                                            
                                        }
                                        .tint(Color.primary)
                                        .frame(width:proxy.size.width - 20)
                                        .background(.thickMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(10)
                                    }
                                }
                            }
                            .scrollIndicators(.never)
                            .refreshable{
                                advertsViewModel.fetchDataWithLocation(lat: mapViewModel.userMapRegion.center.latitude, lon: mapViewModel.userMapRegion.center.longitude, radius: 1)
                            }
                        }
                    }
                }
            }.onAppear{
                advertsViewModel.fetchDataWithLocation(lat: mapViewModel.userMapRegion.center.latitude, lon: mapViewModel.userMapRegion.center.longitude, radius: 1)
                authViewModel.fetchUser()
            }.navigationTitle("Ads Near Me").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.topBarTrailing){
                    Button{
                        isFilterParamsSheetVisible.toggle()
                    } label :{
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .sheet(isPresented: $isFilterParamsSheetVisible) {
                VStack{
                    HStack {
                        TextField("Search", text: $searchText)
                            .padding(.horizontal)
                            .onSubmit {
                                //
                            }
                        Button{
                        } label :{
                            Image(systemName: "magnifyingglass").scaleEffect(1.2).padding(.trailing)
                        }
                    }
                    .padding(.vertical)
                    .background(.regularMaterial).clipShape(Capsule())
                    .padding(.horizontal)
                    RangeSlider(
                                lowValue: $pricelowValue,
                                highValue: $pricehighValue,
                                in: 0.0...1000.0,
                                showDifferenceOnEditing: true) {
                                    isEditing = $0
                                }
                                .padding()
                    
                    
                }.presentationDetents([.large])
            }
            
    }
}

#Preview {
    AdsListView()
}
