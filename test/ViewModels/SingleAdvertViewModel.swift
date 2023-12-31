//
//  AdvertViewModel.swift
//  test
//
//  Created by Cem Dedetas on 2.10.2023.
//

import SwiftUI

class SingleAdvertViewModel: ObservableObject {
    
    
    var adId:String?
    @Published var advert: Advert? = nil
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    init (){
        
    }
    
    func fetchData() {
        // Show loading indicator
        isLoading = true
        
        
        guard let url = URL(string: "http://localhost:3000/api/v1/adverts/\(adId!)") else {
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
                    let decodedResponse = try decoder.decode(SingleAdvertResponse.self, from: data)
                    self?.advert = decodedResponse.data
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
    
    func uploadData(advertRequest: AdvertRequest) {
        isLoading = true
        
        guard let url = URL(string: "http://localhost:3000/api/v1/adverts/create") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request = AuthMiddleware.shared.addToken(to: request)
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(advertRequest)
            request.httpBody = jsonData
        } catch {
            errorMessage = "Failed to encode data"
            isLoading = false
            return
        }

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
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
                    let decodedResponse = try decoder.decode(SingleAdvertResponse.self, from: data)
                    self?.errorMessage = ""
                    self?.advert = decodedResponse.data
                    NotificationCenter.default.post(
                                                                name: Notification.Name("AdvertIDReceived"),
                                                                object: decodedResponse.data._id
                                                            )
                    // Handle the response as needed
                } catch {
                    self?.errorMessage = "Failed to decode response"
                    let localData = try? JSONSerialization.jsonObject(with: data)
                    if let localData = localData {
                        print("Error: \(localData)")
                    }
                }
            }
        }

        task.resume()
    }

    
    func addToFavorites(id:String) {
        // Show loading indicator
        isLoading = true
        
        
        guard let url = URL(string: "http://localhost:3000/api/v1/user/favorite/\(id)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        var request = URLRequest(url: url)
        request = AuthMiddleware.shared.addToken(to: request)
        request.httpMethod = "PATCH"
        
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
                    let decodedResponse = try decoder.decode(UserResponse.self, from: data)
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
    
    func removeFromFavorites(id:String) {
        // Show loading indicator
        isLoading = true
        
        
        guard let url = URL(string: "http://localhost:3000/api/v1/user/unfavorite/\(id)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        var request = URLRequest(url: url)
        request = AuthMiddleware.shared.addToken(to: request)
        request.httpMethod = "PATCH"
        
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
                    let decodedResponse = try decoder.decode(UserResponse.self, from: data)
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


struct SingleAdvertResponse: Decodable {
    let data: Advert
    let message: String
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
        case success
    }
}


