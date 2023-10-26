//
//  AdvertViewModel.swift
//  test
//
//  Created by Cem Dedetas on 2.10.2023.
//

import SwiftUI
import CoreLocation

class MultiAdvertViewModel: ObservableObject {
    
    
    
    @Published var listings: [Advert] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    func fetchData() {
        // Show loading indicator
        isLoading = true
        
        
        guard let url = URL(string: "http://localhost:3000/api/v1/adverts") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        var request = URLRequest(url: url)
        request = AuthMiddleware.shared.addToken(to: request)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                // Hide loading indicator
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter: DateFormatter = {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        return formatter
                    }()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let decodedResponse = try decoder.decode(AdvertResponse.self, from: data)
                    self?.listings = decodedResponse.data
                    self?.errorMessage = ""
                } catch {
                    self?.errorMessage = "Failed to decode response"
                    let localdata = try? JSONSerialization.jsonObject(with: data)
                    if !(localdata == nil) {
                        print("Error: \(localdata!)")
                    }
                }
            }
        }
        
        task.resume()
    }
        
    func fetchDataWithLocation(
        lat:CLLocationDegrees,lon:CLLocationDegrees,radius:CLLocationDegrees
    ) {
            // Show loading indicator
            isLoading = true
            
            
        guard let url = URL(string: "http://localhost:3000/api/v1/adverts/location?lat=\(lat)&lon=\(lon)&radius=\(radius)") else {
                errorMessage = "Invalid URL"
                isLoading = false
                return
            }
        var request = URLRequest(url: url)
        request = AuthMiddleware.shared.addToken(to: request)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    // Hide loading indicator
                    self?.isLoading = false
                    
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let data = data else {
                        self?.errorMessage = "No data received"
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let dateFormatter: DateFormatter = {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                return formatter
                            }()
                        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                        let decodedResponse = try decoder.decode(AdvertResponse.self, from: data)
                        self?.listings = decodedResponse.data
                        self?.errorMessage = ""
                    } catch {
                        self?.errorMessage = "Failed to decode response"
                        let localdata = try? JSONSerialization.jsonObject(with: data)
                        if !(localdata == nil) {
                            print("Error: \(localdata!)")
                        }
                    }
                }
            }
            
            task.resume()
        }
}

struct TestType: Decodable{
    let a: String
}

struct AdvertResponse: Decodable {
    let data: [Advert]
    let message: String
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
        case success
    }
}


