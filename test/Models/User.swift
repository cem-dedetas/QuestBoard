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


struct User: Codable {
    let name: String
    let email: String
    let salt: String
    let profilePicUrl: String
}


