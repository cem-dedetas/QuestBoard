//
//  AuthUtils.swift
//  test
//
//  Created by Cem Dedetas on 25.10.2023.
//

import Foundation
import Security

class JWTTokenManager {

    private static let tokenKey = "YourJWTTokenKey"

    // Store a JWT token in the Keychain
    static func storeJWTToken(_ token: String) {
        KeychainService.save(key: tokenKey, data: token)
    }

    // Retrieve a JWT token from the Keychain
    static func getJWTToken() -> String? {
        return KeychainService.load(key: tokenKey)
    }

    // Delete the JWT token from the Keychain
    static func deleteJWTToken() {
        KeychainService.delete(key: tokenKey)
    }
}

class KeychainService {
    static func save(key: String, data: String) {
        if let data = data.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("Error saving data to Keychain: \(status)")
            }
        }
    }

    static func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            return nil
        }
    }

    static func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Error deleting data from Keychain: \(status)")
        }
    }
}




class AuthMiddleware {
    static let shared = AuthMiddleware()
    private init() {}
    
    // Function to add the JWT token to the authorization header.
    func addToken(to request: URLRequest) -> URLRequest  {
        var request = request
        let token = JWTTokenManager.getJWTToken()
        if let token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
        }
        else {
            print("Could not add token, token not found!")
        }
        return request
    }
}


enum AuthError:Error {
    case noJWTError
}
