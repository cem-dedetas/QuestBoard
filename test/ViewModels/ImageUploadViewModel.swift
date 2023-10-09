//
//  ImageUploadViewModel.swift
//  test
//
//  Created by Cem Dedetas on 8.10.2023.
//

import SwiftUI



class ImageUploadViewModel: ObservableObject {
    @Published var uploadedImages: [UIImage] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    func uploadImages(adId: String, completion: @escaping (Result<Advert?, Error>) -> Void) {
        // Convert UIImage to Data
        isLoading = true
        let imageDatas = uploadedImages.compactMap { image in
            return image.jpegData(compressionQuality: 1)
        }
        
        // Create a multipart form data request
        guard let url = URL(string: "http://localhost:3000/api/v1/adverts/uploadPhotos/\(adId)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Append images to the request
        for (index, data) in imageDatas.enumerated() {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"photos\"; filename=\"image\(index).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(data)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
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
                    let decodedResponse = try decoder.decode(SingleAdvertResponse.self, from: data)
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
