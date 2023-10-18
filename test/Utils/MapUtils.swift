//
//  MapUtils.swift
//  test
//
//  Created by Cem Dedetas on 8.10.2023.
//

import Foundation
import CoreLocation
import MapKit

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

func getEstimatedTime(to destionationLocation:CLLocationCoordinate2D, from currentLocation:CLLocationCoordinate2D) async -> String {
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: .init(coordinate: currentLocation))
    request.destination = MKMapItem(placemark: .init(coordinate: destionationLocation))
    request.transportType = .walking
    
    let result = try? await MKDirections(request: request).calculate()
    if let result = result, let first = result.routes.first{
//        print(first.expectedTravelTime)
        return formatTimeInterval(first.expectedTravelTime)
    }
    return "--:--:--"
}
func formatTimeInterval(_ seconds: TimeInterval) -> String {
    let hours = Int(seconds / 3600)
    let minutes = Int((seconds.truncatingRemainder(dividingBy: 3600)) / 60)
    let secondsRemainder = Int(seconds.truncatingRemainder(dividingBy: 60))
    
    if hours > 0 {
        if minutes > 0 {
            return "\(hours) h \(minutes) m"
        } else {
            return "\(hours) h"
        }
    } else if minutes > 0 {
        return "\(minutes) m"
    } else {
        return "\(secondsRemainder) s"
    }
}
