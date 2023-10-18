//
//  DetailSheetView.swift
//  test
//
//  Created by Cem Dedetas on 23.09.2023.
//

import SwiftUI
import MapKit

struct DetailSheetView: View {
    @Binding var advert:Advert?
    @Binding var isAdDetailPresented:Bool
    @Binding var routeDisplaying:Bool
    @State var sheetRatio = 0.60
    @State var linelimit:Int = 8
    @EnvironmentObject var mapViewModel:MapViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
    VStack {
        if let advert = advert {
                VStack(alignment:.leading){
                    HStack(alignment:.top){
                        Button{
                            dismiss()
                        } label:{
                            HStack{
                                Image(systemName: "chevron.down")
                                Text("Back")
                            }
                        }
                    Spacer()
                        Button{
                            dismiss()
                            isAdDetailPresented.toggle()
                        } label:{
                            HStack{
                                Text("Details")
                                Image(systemName: "chevron.right")
                            }
                        }
                    }.padding()
                    Section{
                        HStack(alignment:.firstTextBaseline) {
                            VStack(alignment: .leading) {
                                Text(advert.title).font(.title)
                            
                            Text("\(enumStrings[advert.adType.rawValue])").foregroundStyle(.gray)
                            }.padding(.horizontal)
                            Spacer()
                            if let address = advert.address {
                                VStack(alignment: .trailing) {
                                    Text(address.city)
                                    Text(address.town).foregroundStyle(.gray)
                                }.padding(.horizontal)
                            }
                        }
                    }
                    Section{
                        
                    }
                    Section{
                        ScrollView(.vertical){
                            VStack{
                                Text(advert.description).lineLimit(linelimit).italic().padding()
                                Button{
                                    withAnimation(.easeInOut){
                                        linelimit = linelimit == 8 ? .max : 8
                                    }
                                } label :{
                                    linelimit == 8 ? Text("See more") : Text("See less")
                                }.padding(.vertical, 10)
                            }
                        }.padding(.bottom)
                    }
                    Section {
                        VStack(alignment:.center){
                            HStack(alignment: .center){
                                Spacer()
                                Button{
                                    routeDisplaying = true
                                } label: {
                                    HStack{
                                        Text("Show Route (")
                                        EstimatedTimeView(from: advert.location2d)
                                        Image(systemName: "figure.walk")
                                        Text(")")
                                    }.padding().background(Color.accentColor).clipShape(.capsule)
                                        .foregroundStyle(Color.white)
                                }
                                Spacer()
                            }
                            Button {
                                let coordinates = advert.location2d
                                let placemark = MKPlacemark(coordinate: coordinates)
                                let mapItem = MKMapItem(placemark: placemark)
                                mapItem.name = advert.title

                                        // Set the options for opening Apple Maps
                                let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]

                                        // Open Apple Maps with the marker centered
                                mapItem.openInMaps(launchOptions: options)
                            } label :{
                                Text("or open with Apple Maps")
                            }
                        }
                    }
                    Spacer()
                }.navigationTitle(advert.title).navigationBarTitleDisplayMode(.inline)
                .presentationDetents([.medium,.large])
            }
            
        }
        
    }
}
    



