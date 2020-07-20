//
//  TinderUserResponseModel.swift
//  DigiTinder
//
//  Created by Kaustubh on 25/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import CoreData

// MARK: Automated Swift Struct Generated from https://app.quicktype.io
// MARK: - ResponseData
//struct ResponseData: Codable {
//    let results: [Result] // MARK: Here Each Result is single user, thue single multiple results could be obtained.
//}
//
//// MARK: - Result
//struct Result: Codable {
//    let user: TinderUserResponseModel // MARK: This should be array to handle multiple users in the response, otherwise the results is handled as single user object,
//    let seed, version: String
//    enum CodingKeys: String, CodingKey {
//        case user, seed, version
//    }
//}
//
//// MARK: - TinderUser
//struct TinderUserResponseModel: Codable {
//    var name: Name
//    var location: Location
//    var gender: String
//    var email, username, password, salt: String
//    var md5, sha1, sha256, registered: String
//    var phone, cell, ssn: String
//    var picture: String
//    var dob: String
//
//    enum CodingKeys: String, CodingKey {
//        case gender, name, location, email, username, password, salt, md5, sha1, sha256, registered, dob, phone, cell
//        case ssn = "SSN"
//        case picture
//    }
//}
//
//// MARK: - Location
//struct Location: Codable {
//    let street, city, state, zip: String
//}
//
//// MARK: - Name
//struct Name: Codable {
//    let title, first, last: String
//}


// MARK: - ResponseData
struct ResponseData: Codable {
    let results: [TinderUserResponseModel]
    //let info: Info
}

//struct Result: Codable {
//}

// MARK: - Info
struct Info: Codable {
    let seed: String
    let results, page: Int
    let version: Float
}

// MARK: - Result
struct TinderUserResponseModel: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob, registered: Dob
    let phone, cell: String
    let id: ID
    let picture: Picture
    let nat: String
}

// MARK: - Dob
struct Dob: Codable {
    let date: String
    let age: Int
}

enum Gender: String, Codable {
    case female = "female"
    case male = "male"
}

// MARK: - ID
struct ID: Codable {
    let name: String
    let value: String?
}

// MARK: - Location
struct Location: Codable {
    let street: Street
    let city, state, country: String
    //let postcode: Postcode
    let coordinates: Coordinates
    let timezone: Timezone
}

//struct Postcode: Codable {
//    let postcode: Int
//}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: String
}

// MARK: - Street
struct Street: Codable {
    let number: Int
    let name: String
}

// MARK: - Timezone
struct Timezone: Codable {
    let offset, timezoneDescription: String

    enum CodingKeys: String, CodingKey {
        case offset
        case timezoneDescription = "description"
    }
}

// MARK: - Login
struct Login: Codable {
    let uuid, username, password, salt: String
    let md5, sha1, sha256: String
}

// MARK: - Name
struct Name: Codable {
    let title: String
    let first, last: String
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String
}
