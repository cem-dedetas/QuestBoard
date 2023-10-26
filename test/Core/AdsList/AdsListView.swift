//
//  AdsListView.swift
//  test
//
//  Created by Cem Dedetas on 16.10.2023.
//

import SwiftUI

struct AdsListView: View {
    @StateObject var advertsViewModel = MultiAdvertViewModel()
    @EnvironmentObject var mapViewModel:MapViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                if advertsViewModel.isLoading {
                    ProgressView()
                } else {
                    GeometryReader{ proxy in
                        VStack(alignment: .center) {
                        ScrollView(.vertical){
                            
                                ForEach(advertsViewModel.listings, id:\._id){ listing in
                                    NavigationLink{
                                        AdDetailsView(adId: listing._id)
                                    } label :{
                                        VStack {
                                            CachedImageView(url: listing.imgURLs[0], width: proxy.size.width).background(.regularMaterial)
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
            }.navigationTitle("Ads Near Me").navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

#Preview {
    AdsListView()
}
