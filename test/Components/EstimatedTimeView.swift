//
//  EstimatedTimeView.swift
//  test
//
//  Created by Cem Dedetas on 16.10.2023.
//

import SwiftUI
import CoreLocation

struct EstimatedTimeView: View {
    @EnvironmentObject var mapViewModel:MapViewModel
    @State var from:CLLocationCoordinate2D
    @State var eta:String = ""
    var body: some View {
        if eta.isEmpty {
            Text("Calculating").onAppear{
                Task {
                    eta = await getEstimatedTime(to: from, from: mapViewModel.userMapRegion.center)
                }
            }
        }
        else{
            HStack{
                Text(eta)
                Image(systemName: "figure.walk")
            }
        }
    }
}
