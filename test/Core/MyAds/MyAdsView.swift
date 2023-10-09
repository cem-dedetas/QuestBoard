//
//  MyAdsScreen.swift
//  test
//
//  Created by Cem Dedetas on 24.09.2023.
//

import SwiftUI

struct MyAdsView: View {
    @StateObject var advertvm = MultiAdvertViewModel()
    @State var isActive : Bool = false
    var body: some View {
        NavigationStack{
            if !isActive {
                VStack{
                    if advertvm.isLoading {
                        ProgressView("Loading...")
                    }
                    else {
                        if(!advertvm.errorMessage.isEmpty){
                            Text("Error: \(advertvm.errorMessage)")
                        }
                        else {
                            List{
                                ForEach(advertvm.listings, id:\.self._id){ad in
                                    NavigationLink{
                                        AdDetailsView(adId:ad._id)
                                    } label :{
                                        VStack(alignment: .leading){
                                            Text("\(ad.title)")
                                            Text("\(ad.description)").font(.footnote).foregroundStyle(.gray).lineLimit(1)
                                            
                                        }
                                    }
                                }
                            }.refreshable{
                                advertvm.fetchData()
                            }
                            
                        }
                    }
                }.navigationDestination(isPresented: $isActive){
                    CreateAdView(stackIsActive: $isActive)
                }
                .navigationTitle("My Ads")
                    .toolbar{
                        ToolbarItem{
                            Button{
                                isActive.toggle()
                            } label: {
                                Text("Create")
                            }
                        }
                }
            } else {
                /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
            }
        }.onAppear {
            // Fetch data when the view appears
            advertvm.fetchData()
        }
        
        
    }
}

#Preview {
    MyAdsView()
}
