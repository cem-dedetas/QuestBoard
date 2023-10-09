//
//  User.swift
//  test
//
//  Created by Cem Dedetas on 19.09.2023.
//

import Foundation


struct User:Identifiable,Codable {
    let id: String
    let fullName:String
    let email:String
    
    
}

extension User {
    static var MOCKUSER = User(id: UUID().uuidString, fullName: "Cem Dedetas", email: "cemdedetas@gmail.com")
}
