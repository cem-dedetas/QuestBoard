//
//  MapView.swift
//  test
//
//  Created by Cem Dedetas on 20.09.2023.
//

import SwiftUI
import MapKit



struct MapView: View {
    @StateObject var mapViewModel = MapViewModel()
    @Namespace var mapScope
    let testMarker:Advert = Advert(id: UUID().uuidString, title: "AppleHQ", adType: AdvertTypeEnum.realEstate, description: "Description", price: 99, email: "cemdedetas@gmail.com", imgURLs: [""], phone: "+905555555", createdAt: Date().formatted(), location: Location(lat: 37.3317, lon: -122.0307))
    let markerPos = CLLocationCoordinate2D(latitude: 37.3317, longitude:  -122.0307)
    @State var mapCameraPosition : MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @State var selectedMarker:Advert = Advert(id: UUID().uuidString, title: "AppleHQ", adType: AdvertTypeEnum.realEstate, description: "Description", price: 99, email: "cemdedetas@gmail.com", imgURLs: [""], phone: "+905555555", createdAt: Date().formatted(), location: Location(lat: 37.3317, lon: -122.0307))
    @State var sheetIsPresented:Bool = false
    
    var body: some View {
            Map(position: $mapCameraPosition, scope:mapScope){
                UserAnnotation()
                Annotation(testMarker.title,coordinate:testMarker.location2d){
                    Button {
                        selectedMarker = testMarker
                        sheetIsPresented = true
                    }label:{
                        VStack{
                            Image(systemName: "house.circle.fill").resizable().scaledToFit().frame(width: 40, height: 40)
                            Image(systemName: "triangle.fill").resizable().scaledToFit().frame(width: 20, height: 20).rotationEffect(.degrees(180.0), anchor: .top)
                        }.tint(.red)
                    }
                }
            }
//            .ignoresSafeArea(.all)
            .mapControlVisibility(.hidden)
                .overlay(alignment:.bottomTrailing){
                    VStack{
                        MapUserLocationButton(scope: mapScope)
                        MapCompass(scope: mapScope)
                            .mapControlVisibility(.visible)
                        //                    MapPitchButton()
                    }
                    .padding(.trailing)
                    .padding(.bottom,100)
                        .buttonBorderShape(.roundedRectangle)
                }
                .overlay(alignment: .topTrailing){
                    ZStack{
                        Button{
                            print("test123")
                        }label:{
                            Image(systemName: "line.horizontal.3").resizable().padding(10).frame(width: 40,height: 40)
                        }.background(Color(.secondarySystemBackground)).buttonBorderShape(.roundedRectangle).cornerRadius(5)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        
                    }.padding()
                }
                .mapScope(mapScope)
                .onAppear{
                    mapViewModel.checkLocationServicesEnabled()
                }
                .sheet(isPresented: $sheetIsPresented){
                    DetailSheetView(advert:$selectedMarker)
                }
            
    }
}

extension Advert {
    var location2d: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: self.location.lat, longitude: self.location.lon)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
