//
//  AdDetailsView.swift
//  test
//
//  Created by Cem Dedetas on 30.09.2023.
//

import SwiftUI
import MapKit
import Foundation

struct AdDetailsView: View {
    
    func getDateFromString(_ dateString: String) -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(identifier: "UTC") // Set the appropriate time zone
            
            return dateFormatter.date(from: dateString)
        }
    
    var adId:String;
    @ObservedObject var advertvm:SingleAdvertViewModel;
    @State var currentImageIndex:Int = 0
    
    init (adId:String){
        self.adId = adId
        advertvm = SingleAdvertViewModel(adId: adId)
    }
    var body: some View {
        ScrollView(.vertical) {
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
                            
                            if !advertvm.advert.imgURLs.isEmpty {
                                ImageCarouselView(index: $currentImageIndex, items: advertvm.advert.imgURLs){ photoUrl in
                                    VStack{
                                        GeometryReader{proxy in
                                            let size = proxy.size
                                            CachedImageView(url: photoUrl, width:size.width)
                                        }
                                    }
                                    
                                }.frame(height: 300)
                            }
                            Section{
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(advertvm.advert.title).font(.title)
                                    
                                    Text("\(enumStrings[advertvm.advert.adType.rawValue])").foregroundStyle(.gray)
                                    }.padding(.horizontal)
                                    Spacer()
                                    if let address = advertvm.advert.address {
                                        VStack(alignment: .trailing) {
                                            Text(address.country)
                                            
                                            Text("\(address.city) / \(address.town)").foregroundStyle(.gray)
                                        }.padding(.horizontal)
                                    }
                                }
                            }
                            Divider()
                            Section{
                                Text(advertvm.advert.description)
                                    .foregroundStyle(.primary.opacity(0.7))
                                    .padding()
                            }
                            Divider()
                            ZStack {
                                Map(initialPosition: .camera(.init(centerCoordinate: advertvm.advert.location2d, distance: 2500)),
                                    interactionModes: []
                                ){
                                    Marker(advertvm.advert.title, systemImage: "chevron.down", coordinate: advertvm.advert.location2d)
                                }
                            .frame(height: 300)
                                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]), startPoint: .top, endPoint: .bottom)
                                                .frame(height: 300)
                                VStack {
                                    NavigationLink{
                                        DetailMapView(location: advertvm.advert.location2d, label:advertvm.advert.title)
                                    } label :{
                                        HStack {
                                            Text("Show in map")
                                            Image(systemName: "chevron.right")
                                        }
                                        .padding()
                                        .background(.regularMaterial)
                                        .clipShape(.capsule)
                                    }.padding(.top,25)
                                    Spacer()
                                }
                                
                            }
                            Divider()
                            Section{
                                Button{
                                    
                                } label : {
                                    HStack {
                                        Text("Get in contact")
                                        Image(systemName: "phone")
                                        Image(systemName: "envelope")
                                    }
                                }
                            }.padding()
                            Divider()
                        }
                    }
                }
            }
            .onAppear {
                advertvm.fetchData()
            }
            .navigationBarTitle(advertvm.advert.title)
        .navigationBarTitleDisplayMode(.inline)
        }.padding(.bottom, 50)
    }
}

#Preview {
    AdDetailsView(adId: "651d7dcf7afbc3ac494d2077")
}
