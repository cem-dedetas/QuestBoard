//
//  DetailMapView.swift
//  test
//
//  Created by Cem Dedetas on 10.10.2023.
//

import SwiftUI
import MapKit

struct DetailMapView: View {
    @ObservedObject var mapVM = MapViewModel()
    @Namespace var mapScope
    let location:CLLocationCoordinate2D
    let label:String
    var body: some View {
        Map(initialPosition: .camera(.init(centerCoordinate: location, distance: 2500))
        ){
            Marker(label, image: "chevron.down", coordinate: location)
        }
        .onAppear{
            mapVM.checkLocationServicesEnabled()
        }.mapControls{
            MapUserLocationButton()
            MapPitchToggle()
        }
    }
}
