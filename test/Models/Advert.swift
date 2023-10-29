import Foundation

struct Location: Codable, Hashable {
    let lat: Double
    let lon: Double
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

enum AdvertTypeEnum: Int, Codable,CaseIterable, Hashable {
    case realEstate
    case vehicle
    case other
}

struct Address: Codable, Hashable {
    let country:String
    let zipCode:String
    let city:String
    let town:String
    let rest:String
}

struct Advert: Codable, Hashable{
    let _id: String
    let title: String
    let adType: AdvertTypeEnum // Use the enum type here
    let description: String
    let price: Int
    let email: String
    let imgURLs: [String]
    let phone: String
    let createdAt: String
    let location: Location
    let address: Address?
    let patron : User
    let likeCount:Int
    // Provide an initializer for the Advert struct
    init(id: String, title: String, adType: AdvertTypeEnum, description: String, price: Int, email: String, imgURLs: [String], phone: String, createdAt: String, location: Location, address: Address? = nil) {
        self._id = id
        self.title = title
        self.adType = adType
        self.description = description
        self.price = price
        self.email = email
        self.imgURLs = imgURLs
        self.phone = phone
        self.createdAt = createdAt
        self.location = location
        self.address = address
        self.patron = User(name: "", email: "", profilePicUrl: "", favorites: [])
        self.likeCount = 0
    }
}

struct AdvertRequest: Codable {
    let title: String
    let description: String
    let adType: AdvertTypeEnum
    let price: Double
    let email: String
    let phone: String
    let location: Location
    let address: Address
}

public var enumStrings: [String] = ["Real Estate", "Vehicle","Other"]
