//
//  Chat.swift
//  test
//
//  Created by Cem Dedetas on 31.10.2023.
//

import Foundation


struct Chat : Codable {
    let _id : String
    let chatUUID : String
    let advert : Advert
    let users : [User]
}

struct MultiChatResponse : Decodable {
    let data : [Chat]
    let message: String
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
        case success
    }
}


struct SingleChatResponse : Decodable {
    let data : Chat?
    let message: String
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
        case success
    }
}
