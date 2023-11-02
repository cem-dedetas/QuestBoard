//
//  MyAdsScreen.swift
//  test
//
//  Created by Cem Dedetas on 24.09.2023.
//

import SwiftUI

struct FavoriteAdsView: View {
    @EnvironmentObject var advertvm:MultiAdvertViewModel
    @State var isActive : Bool = false
    var body: some View {
                    VStack{
                        if advertvm.isLoading {
                            Spacer()
                                ProgressView("Loading...")
                            Spacer()
                            
                        }
                        else {
                            if(!advertvm.errorMessage.isEmpty){
                                Text("Error: \(advertvm.errorMessage)")
                            }
                            else {
                                List{
                                    ForEach(advertvm.listings, id:\.self._id){ad in
                                        NavigationLink{
                                            AdDetailsView(advert:ad)
                                        } label :{
                                            VStack(alignment: .leading){
                                                Text("\(ad.title)")
                                                Text("\(ad.description)").font(.footnote).foregroundStyle(.gray).lineLimit(1)
                                                
                                            }
                                        }
                                    }
                                }.refreshable{
                                    advertvm.fetchFavorites()
                                }
                                
                            }
                        }
                }.onAppear {
                    // Fetch data when the view appears
                    advertvm.fetchFavorites()
                }.navigationTitle("Favorites")
        
        
        
    }
}

