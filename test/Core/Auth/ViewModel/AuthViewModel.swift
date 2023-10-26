//
//  AuthViewModel.swift
//  test
//
//  Created by Cem Dedetas on 19.09.2023.
//

import Foundation


@MainActor
class AuthViewModel : ObservableObject {
    @Published var userToken: String?
    @Published var currentUser: User?
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    init(){
        userToken = JWTTokenManager.getJWTToken()
        fetchUser()
    }
    
    func signIn(email: String, password:String) async throws {
        isLoading = true
        let requestParams = LoginRequest(password: password, email: email)
        
        guard let url = URL(string: "http://localhost:3000/api/v1/auth/login") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(requestParams)
            request.httpBody = jsonData
        } catch {
            errorMessage = "Failed to encode data"
            isLoading = false
            return
        }
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
                    let decodedResponse = try decoder.decode(AuthResponse.self, from: data)
                    if let responseToken = decodedResponse.data {
                        self?.userToken = responseToken
                        try JWTTokenManager.deleteJWTToken()
                        try JWTTokenManager.storeJWTToken(responseToken)
                        self?.fetchUser()
                    }
                    else {
                        throw DecodingError.invalidData
                    }
                    self?.errorMessage = ""
                } catch {
                    self?.errorMessage = "Failed to decode response"
                }
            }
        }
        
        task.resume()
    }
    
    func register(email: String, password:String, fullname:String) async throws {
        isLoading = true
        let requestParams = RegisterRequest(fullName: fullname, password: password, email: email)
        
        guard let url = URL(string: "http://localhost:3000/api/v1/auth/register") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(requestParams)
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
                    let decodedResponse = try decoder.decode(AuthResponse.self, from: data)
                    self?.errorMessage = ""
                    if let responseToken = decodedResponse.data {
                        self?.userToken = responseToken
                        try JWTTokenManager.deleteJWTToken()
                        try JWTTokenManager.storeJWTToken(responseToken)
                        
                        self?.fetchUser()
                    }
                    else {
                        throw DecodingError.invalidData
                    }
                } catch {
                    self?.errorMessage = "Failed to decode response"
                }
            }
        }

        task.resume()
    }
    
    func signOut(){
        self.userToken = nil
        self.currentUser = nil
        do {
            try JWTTokenManager.deleteJWTToken()
        } catch {
            self.errorMessage = "Error deleting JWT token from keychain"
        }
        
    }
    
    func fetchUser() {
        // Show loading indicator
        isLoading = true
        
        
        guard let url = URL(string: "http://localhost:3000/api/v1/auth/userWithToken") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Set the Authorization header with the JWT token
            if let token = self.userToken {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        
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
                    if let respUser = decodedResponse.data {
                        self?.currentUser = respUser
                    }
                    else {
                        throw DecodingError.invalidData
                    }
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

enum DecodingError: Error {
    case invalidData
    case missingValue
}

enum StoringError: Error {
    case JWTStorageError
}

struct AuthResponse: Codable {
    let data: String?
    let message: String
    let success: Bool
}

struct UserResponse: Codable {
    let data: User?
    let message: String
    let success: Bool
}
