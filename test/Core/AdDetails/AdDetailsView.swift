//
//  AdDetailsView.swift
//  test
//
//  Created by Cem Dedetas on 30.09.2023.
//

import SwiftUI

struct AdDetailsView: View {
    var adId:String;
    @ObservedObject var advertvm:SingleAdvertViewModel;
    @State var currentImageIndex:Int = 0
    
    init (adId:String){
        self.adId = adId
        advertvm = SingleAdvertViewModel(adId: adId)
    }
    var body: some View {
        VStack {
            if advertvm.isLoading {
                ProgressView("Loading...")
            } 
            else {
                if !advertvm.errorMessage.isEmpty {
                    Text(advertvm.errorMessage)
                        .foregroundColor(.red)
                }
                else{
                    VStack(alignment: .leading){
                        Section{
                            Text(advertvm.advert.title).font(.title)
                            Text(advertvm.advert.description)
                        }
                        Divider()
                        Section{
                            Text(advertvm.advert.phone)
                            Text(advertvm.advert.email)
                        }
                        Spacer()
                        Divider()
                        Text("Map here")
                        Divider()
                        Section{
                            ImageCarouselView(index: $currentImageIndex, items: advertvm.advert.imgURLs){ photoUrl in
                                GeometryReader{proxy in
                                    let size = proxy.size
                                    ImageLoader(from: photoUrl, width:size.width)
                                }
                                
                            }
                        } header:{
                            Text("Images")
                        }
                        Divider()
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            advertvm.fetchData()
        }
        .navigationBarTitle(advertvm.advert.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AdDetailsView(adId: "651d7dcf7afbc3ac494d2077")
}
