//
//  MapViewModel.swift
//  test
//
//  Created by Cem Dedetas on 20.09.2023.
//

import Foundation
import MapKit


final class MapViewModel: NSObject, ObservableObject,CLLocationManagerDelegate {
    @Published var userMapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.03322, longitude: 29.00000), span: MKCoordinateSpan(latitudeDelta: 0.208, longitudeDelta: 0.208))
    var locationManager:CLLocationManager?
    func checkLocationServicesEnabled(){
        if(!CLLocationManager.locationServicesEnabled()){
            
        }
        else{
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        }
    }
    
    func printLocation(){
        print(locationManager?.location?.coordinate.latitude)
    }
    
    private func checkLocationPermissions (){
        guard let locationManager = locationManager else {return}
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("")
        case .denied:
            print("")
        case .authorizedAlways,.authorizedWhenInUse:
            userMapRegion = MKCoordinateRegion(center:locationManager.location!.coordinate,span:MKCoordinateSpan(latitudeDelta: 0.208, longitudeDelta: 0.208))
            break
        @unknown default:
            print("")
        }
    }
        
    func locationManagerDidChangeAuthorization(_ manager:CLLocationManager){
        checkLocationPermissions()
    }
}
