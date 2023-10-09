//
//  SelectLocationView.swift
//  test
//
//  Created by Cem Dedetas on 5.10.2023.
//

import SwiftUI
import MapKit

struct SelectLocationView: View {
    @Namespace var selectLocationMapScope
    @State var mapCameraPosition : MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @Binding var coord:CLLocationCoordinate2D
    @State var temp:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.03322, longitude: 29.00000)
    @Binding var isSet:Bool
    @State var tempPlacemark:CLPlacemark? = nil
    @Binding var address:CLPlacemark?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Map(position: $mapCameraPosition, scope:selectLocationMapScope){
        }
        .onMapCameraChange { context in
            temp = context.region.center
            print("\(context.region.center.latitude), \(context.region.center.longitude)")
            convertCoordinatesToAddress(latitude: temp.latitude, longitude: temp.longitude){ placemark in
                if let placemark = placemark {
                        tempPlacemark = placemark
                    } else {
                        tempPlacemark = nil
                    }
            }
        }
        .overlay(alignment:.center){
            VStack{
                Image(systemName: "house.circle.fill").resizable().scaledToFit().frame(width: 40, height: 40)
                Image(systemName: "triangle.fill").resizable().scaledToFit().frame(width: 20, height: 20).rotationEffect(.degrees(180.0), anchor: .top)
            }
            .offset(y:-30)
            .tint(.red)
        }
        .overlay{
            VStack(spacing:20){
                Spacer()
                if let _address = tempPlacemark {
                    VStack{
                        Text("\(_address.name ?? "") \(_address.thoroughfare ?? ""), \(_address.locality ?? "") \(_address.administrativeArea ?? "") \(_address.postalCode ?? "") \(_address.country ?? "")")
                            .padding()
                            
                    }.background(Color.white)
                        .clipShape(.capsule)
                        .shadow(radius:  10)
                    
                }
                Button {
                    coord = temp
                    dismiss()
                    address = tempPlacemark
                    isSet = true
                }label : {
                    HStack{
                        Text("Save Location").fontWeight(.semibold)
                        Image(systemName: "arrow.right.square.fill")
                    }.foregroundColor(.white)
                        
                    
                }.frame(width: UIScreen.main.bounds.width - 36, height: 40)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .padding(.bottom,50)
            }
        }.mapScope(selectLocationMapScope)
            .navigationTitle("Select Location")
//            .toolbar{
//                ToolbarItem{
//                    Button{
//                        coord = temp
//                        dismiss()
//                    } label:{
//                        HStack{
//                            Text("Done")
//                            Image(systemName: "chevron.right")
//                        }
//                    }
//                }
//            }
    }
}
