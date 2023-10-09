//
//  MapUtils.swift
//  test
//
//  Created by Cem Dedetas on 8.10.2023.
//

import Foundation
import CoreLocation

func convertCoordinatesToAddress(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler: @escaping (CLPlacemark?) -> Void) {
    let location = CLLocation(latitude: latitude, longitude: longitude)
    let geocoder = CLGeocoder()

    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
        if let error = error {
            print("Reverse geocoding error: \(error.localizedDescription)")
            completionHandler(nil)
            return
        }

        if let placemark = placemarks?.first {
            // You can format the address as you like by combining the address components.
            let address = "\(placemark.name ?? "") \(placemark.thoroughfare ?? ""), \(placemark.locality ?? "") \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "") \(placemark.country ?? "")"
            
            completionHandler(placemark)
        } else {
            completionHandler(nil)
        }
    }
}
