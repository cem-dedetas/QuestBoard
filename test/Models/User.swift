//
//  User.swift
//  test
//
//  Created by Cem Dedetas on 19.09.2023.
//

import Foundation


struct RegisterRequest:Codable {
    let fullName:String
    let password:String
    let email:String
}

struct LoginRequest:Codable {
    let password:String
    let email:String
}


struct User: Codable, Hashable {
    let name: String
    let email: String
    let profilePicUrl: String
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

