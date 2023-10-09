//
//  AdvertViewModel.swift
//  test
//
//  Created by Cem Dedetas on 2.10.2023.
//

import SwiftUI

class SingleAdvertViewModel: ObservableObject {
    
    
    var adId:String?
    @Published var advert: Advert = Advert(id: "", title: "", adType: AdvertTypeEnum.other, description: "", price: 0, email: "", imgURLs: [""], phone: "", createdAt: "", location: Location(lat: 0, lon: 0))
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    init(adId: String?) {
        if( !(adId == nil) ){
            self.adId = adId
        }
    }
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
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
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
                    NotificationCenter.default.post(
                                            name: Notification.Name("AdvertIDReceived"),
                                            object: decodedResponse.data._id
                                        )
                    self?.errorMessage = ""
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


