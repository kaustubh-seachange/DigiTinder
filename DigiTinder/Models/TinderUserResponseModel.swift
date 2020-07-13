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
struct ResponseData: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let user: TinderUserResponseModel
    let seed, version: String
    enum CodingKeys: String, CodingKey {
        case user, seed, version
    }
}

// MARK: - TinderUser
struct TinderUserResponseModel: Codable {
    var name: Name
    var location: Location
    var gender: String
    var email, username, password, salt: String
    var md5, sha1, sha256, registered: String
    var phone, cell, ssn: String
    var picture: String
    var dob: String
    
    enum CodingKeys: String, CodingKey {
        case gender, name, location, email, username, password, salt, md5, sha1, sha256, registered, dob, phone, cell
        case ssn = "SSN"
        case picture
    }
}

// MARK: - Location
struct Location: Codable {
    let street, city, state, zip: String
}

// MARK: - Name
struct Name: Codable {
    let title, first, last: String
}
