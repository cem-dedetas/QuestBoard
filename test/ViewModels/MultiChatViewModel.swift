//
//  ChatsViewModel.swift
//  test
//
//  Created by Cem Dedetas on 31.10.2023.
//

import Foundation


class MultiChatViewModel : ObservableObject {
    
    @Published var chats: [Chat] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    func fetchData() {
        // Show loading indicator
        isLoading = true
        
        
        guard let url = URL(string: "http://localhost:3000/api/v1/chats") else {
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
                    let decodedResponse = try decoder.decode(MultiChatResponse.self, from: data)
                    self?.chats = decodedResponse.data
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
    
    func createChat(adId: String, completion: @escaping (Result<Chat?, Error>) -> Void) {
        // Convert UIImage to Data
        isLoading = true
        
        // Create a multipart form data request
        guard let url = URL(string: "http://localhost:3000/api/v1/chats/newChat/\(adId)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        var request = URLRequest(url: url)
        request = AuthMiddleware.shared.addToken(to: request)
        request.httpMethod = "POST"
        
        
        // Create a URLSessionDataTask to perform the upload
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(SingleChatResponse.self, from: data)
                    self.errorMessage = ""
                    completion(.success(decodedResponse.data))
                    // Handle the response as needed
                } catch {
                    self.errorMessage = "Failed to decode response"
                    let localData = try? JSONSerialization.jsonObject(with: data)
                    if let localData = localData {
                        print("Error: \(localData)")
                    }
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
