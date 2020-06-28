//
//  PostModel.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Swift Struct Generated from https://app.quicktype.io

// let digiTinderModel = try? newJSONDecoder().decode(DigiTinderModel.self, from: jsonData)

import Foundation

// MARK: - DigiTinderModel
struct DigiTinderModel: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let user: User
    let seed, version: String
}

// MARK: - User
struct User: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email, username, password, salt: String
    let md5, sha1, sha256, registered: String
    let dob, phone, cell, ssn: String
    let picture: String

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
