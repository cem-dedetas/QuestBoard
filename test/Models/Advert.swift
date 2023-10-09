import Foundation

struct Location: Codable {
    let lat: Double
    let lon: Double
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

enum AdvertTypeEnum: Int, Codable,CaseIterable {
    case realEstate
    case vehicle
    case other
}

struct Advert: Codable{
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

    // Provide an initializer for the Advert struct
    init(id: String, title: String, adType: AdvertTypeEnum, description: String, price: Int, email: String, imgURLs: [String], phone: String, createdAt: String, location: Location) {
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
}
