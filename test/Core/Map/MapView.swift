//
//  MapView.swift
//  test
//
//  Created by Cem Dedetas on 20.09.2023.
//

import SwiftUI
import MapKit



struct MapView: View {
    @EnvironmentObject var mapViewModel:MapViewModel
    @StateObject var advertsViewModel = MultiAdvertViewModel()
    @Namespace var mapScope
    @State var mapCameraPosition : MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @State var selectedMarker:Advert? = nil
    @State var sheetIsPresented:Bool = false
    @State var isAdDetailPresented:Bool = false
    @State var eta:TimeInterval?
    @State var routeDisplaying = false
    @State var route: MKRoute?
    
    var body: some View {
        NavigationStack {
            Map(position: $mapCameraPosition, scope:mapScope){
                    UserAnnotation()
                    ForEach(advertsViewModel.listings, id:\._id){ listing in
                        Annotation("\(listing.title.prefix(15)) \(listing.title.count > 15 ?  "..." : "" )",coordinate:listing.location2d){
                            Button {
                                selectedMarker = listing
                                sheetIsPresented = true
                            }label:{
                                VStack{
                                    Image(systemName: "house.circle.fill").resizable().scaledToFit().frame(width: 40, height: 40)
                                }.tint(.red)
                            }
                        }
                    }
                    if let route, routeDisplaying {
                        MapPolyline(route.polyline)
                            .stroke(.blue, lineWidth: 6)
                    }
                
            }
                .onMapCameraChange { proxy in
    //                let x1 = "\(proxy.region.center.latitude + proxy.region.span.latitudeDelta)"
    //                let x2 = "\(proxy.region.center.latitude - proxy.region.span.latitudeDelta)"
    //                
    //                let y1 = "\(proxy.region.center.longitude - proxy.region.span.longitudeDelta)"
    //                let y2 = "\(proxy.region.center.longitude + proxy.region.span.longitudeDelta)"
    //                
    //                print(x1,y1)
    //                print(x2,y2)
    //                print("__")
                    advertsViewModel.fetchDataWithLocation(lat: proxy.region.center.latitude , lon: proxy.region.center.longitude, radius: max(proxy.region.span.longitudeDelta, proxy.region.span.latitudeDelta))
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
                        VStack{
                            ZStack{
                                Button{
                                    print("test123")
                                    routeDisplaying = false
                                }label:{
                                    Image(systemName: "line.horizontal.3").resizable().padding(10).frame(width: 40,height: 40)
                                }.background(Color(.secondarySystemBackground)).buttonBorderShape(.roundedRectangle).cornerRadius(5)
                                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                
                            }.padding()
                            if routeDisplaying, route != nil {
                                HStack {
                                    Button{
                                        routeDisplaying = false
                                    }label:{
                                        Image(systemName: "xmark").resizable().padding(10).frame(width: 40,height: 40).tint(.red)
                                    }.background(Color(.secondarySystemBackground)).buttonBorderShape(.roundedRectangle).cornerRadius(5)
                                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                    
                                    if let eta = eta {
                                        Text( formatTimeInterval(eta) )
                                    }
                                }
                            }
                        }
                    }
                    .mapScope(mapScope)
                    .onAppear{
                        mapViewModel.checkLocationServicesEnabled()
                    }
                    .sheet(isPresented: $sheetIsPresented){
                        DetailSheetView(advert:$selectedMarker, isAdDetailPresented: $isAdDetailPresented, routeDisplaying: $routeDisplaying)
                            
                    }
                    .navigationDestination(isPresented: $isAdDetailPresented){
                        if let ad = selectedMarker {
                            AdDetailsView(adId: ad._id)
                        }
                    }.onChange(of:routeDisplaying){ previous, current in
                        if current, let marker = selectedMarker {
                            getRoute(to: marker.location2d)
                        }
                    }
        }
            
    }
    
}

extension MapView{
    func getRoute(to destionationLocation:CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: mapViewModel.userMapRegion.center))
        request.destination = MKMapItem(placemark: .init(coordinate: destionationLocation))
        
        Task{
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            withAnimation(.snappy){
                routeDisplaying = true
                sheetIsPresented = false
                if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                    mapCameraPosition = .rect(rect)
                }
            }
            eta = result?.routes.first?.expectedTravelTime
        }
    }
    func formatTimeInterval(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds / 3600)
        let minutes = Int((seconds.truncatingRemainder(dividingBy: 3600)) / 60)
        let secondsRemainder = Int(seconds.truncatingRemainder(dividingBy: 60))
        
        if hours > 0 {
            if minutes > 0 {
                return "\(hours) hr \(minutes) min"
            } else {
                return "\(hours) hr"
            }
        } else if minutes > 0 {
            return "\(minutes) min"
        } else {
            return "\(secondsRemainder) sec"
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
        MapView().environmentObject(MapViewModel())
    }
}
