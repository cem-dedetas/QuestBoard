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
                                    VStack {
                                        ImageLoader(from: listing.imgURLs[0], width: proxy.size.width).background(.regularMaterial)
                                            .overlay(alignment:.bottomTrailing){
                                                EstimatedTimeView(from: listing.location2d).padding().background(.regularMaterial).padding(.bottom)
                                            }
                                        HStack{
                                            VStack(alignment:.leading){
                                                Text(listing.title).font(.title2)
                                                if let address = listing.address{
                                                    Text("\(address.city) - \(address.town)").font(.footnote)
                                                }
                                            }
                                            Spacer()
                                            NavigationLink{
                                                AdDetailsView(adId: listing._id)
                                            } label :{
                                                HStack {
                                                    Text("Details")
                                                    Image(systemName: "chevron.right")
                                                }.padding().background(Color.accentColor).foregroundStyle(Color.white).clipShape(Capsule())
                                            }
                                            
                                        }.padding()
                                        
                                            .frame(width:proxy.size.width)
                                        .background(.regularMaterial)
                                        .padding(.bottom)
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                }
            }.onAppear{
                advertsViewModel.fetchDataWithLocation(lat: mapViewModel.userMapRegion.center.latitude, lon: mapViewModel.userMapRegion.center.longitude, radius: 1)
            }.navigationTitle("Ads Near Me")
        }
    }
}

#Preview {
    AdsListView()
}
