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
    @State var displayedTab:String = "myads"
    var body: some View {
            VStack{
                HStack{
                    Text(displayedTab == "myads" ? "My Ads" : "Favorites" ).font(.largeTitle).bold()
                    Spacer()
                    if displayedTab == "myads" {
                        Button{
                            isActive.toggle()
                        } label: {
                            HStack{
                                Text("Create")
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                }.padding()
                Picker("", selection: $displayedTab) {
                    Text("My Ads").tag("myads")
                    
                    Text("Favorites") .tag("favorites")
                }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal)
                
                if(displayedTab == "favorites"){
                    FavoriteAdsView().environmentObject(advertvm).padding(.bottom, 50)
                    
                }
                else if (displayedTab == "myads"){
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
                                    advertvm.fetchData()
                                }
                                
                            }
                        }
                    }
                    .padding(.bottom, 50)
                    
                        .onAppear {
                            // Fetch data when the view appears
                            advertvm.fetchData()
                        }
                }
                    
                Spacer()
            }
            .navigationDestination(isPresented: $isActive){
                CreateAdView(stackIsActive: $isActive)
            }
        
        
        
    }
}

#Preview {
    MyAdsView()
}
