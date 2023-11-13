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
    @EnvironmentObject var authViewModel:AuthViewModel
    @State var advert:Advert
    @State var chat:Chat? = nil
    @StateObject var chatsVM =  MultiChatViewModel()
    @State var sendMessage = false
    func getDateFromString(_ dateString: String) -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(identifier: "UTC") // Set the appropriate time zone
            
            return dateFormatter.date(from: dateString)
        }
    
    @State var currentImageIndex:Int = 0
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                VStack(alignment: .leading){
                    
                    if  !advert.imgURLs.isEmpty {
                        ImageCarouselView(index: $currentImageIndex, items: advert.imgURLs){ photoUrl in
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
                                Text(advert.title).font(.title)
                            
                            Text("\(enumStrings[advert.adType.rawValue])").foregroundStyle(.gray)
                            }.padding(.horizontal)
                            Spacer()
                            if let address = advert.address {
                                VStack(alignment: .trailing) {
                                    Text(address.country)
                                    
                                    Text("\(address.city) / \(address.town)").foregroundStyle(.gray)
                                }.padding(.horizontal)
                            }
                        }
                    }
                    Divider()
                    Section{
                        VStack(alignment: .leading){
                            Text("Advertiser").font(.headline)
                        HStack{
                            ProfilePicComponent(user: advert.patron, width: 50)
                            
                                
                                Text(advert.patron.name)
                            }
                        }.padding(.horizontal)
                    }
                    Divider()
                    Section{
                        Text(advert.description)
                            .foregroundStyle(.primary.opacity(0.7))
                            .padding()
                    }
                    Divider()
                    ZStack {
                        Map(initialPosition: .camera(.init(centerCoordinate: advert.location2d, distance: 2500)),
                            interactionModes: []
                        ){
                            Marker(advert.title, systemImage: "chevron.down", coordinate: advert.location2d)
                        }
                    .frame(height: 300)
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]), startPoint: .top, endPoint: .bottom)
                                        .frame(height: 300)
                        VStack {
                            NavigationLink{
                                DetailMapView(location: advert.location2d, label:advert.title)
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
                            chatsVM.createChat(adId: advert._id) { result in
                                
                                switch(result){
                                case .success(let resultChat):
                                    self.chat = resultChat
                                    self.sendMessage = true
                                case .failure(let e):
                                    print(e.localizedDescription)
                                }
                                
                            }
                        } label : {
                            HStack {
                                Text("Send a message")
                                Image(systemName: "envelope")
                            }
                        }
                    }.padding()
                    Divider()
                }.navigationDestination(isPresented: $sendMessage) {
                    if let chat {
                        ChatView(chat: chat, chatViewModel: SingleChatViewModel(chatId: chat.chatUUID))
                    }
                }
            
        
    }
        .navigationBarTitle(advert.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                LikeButtonComponent(adId: advert._id, isFavorited:authViewModel.currentUser?.favorites.contains(where: { element in
                    element == advert._id
                }) ?? false )
            }
        }
        }
        
    }
}
