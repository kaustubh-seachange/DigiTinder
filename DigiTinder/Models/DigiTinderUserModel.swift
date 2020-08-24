//
//  DigiTinderUserModel.swift
//  DigiTinder
//
//  Created by Kaustubh on 06/08/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import CoreData

// MARK: - ResponseData
@objcMembers class ResponseData: Codable {
    enum ResponseKeys: String, CodingKey {
        case results = "results"
    }
    
    var users: [User] = []

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: ResponseKeys.self)
        self.users = try container.decodeIfPresent([User].self, forKey: .results)!
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ResponseKeys.self)
        try container.encode(users, forKey: .results)
        //try container.encode(info, forKey: .info)
    }
}

// MARK: - Info
//@objcMembers class Info: Codable {
//    enum InfoKeys: String, CodingKey {
//        case seed = "seed"
//        case results = "results"
//        case page = "page"
//        case version = "version"
//    }
//
//    var seed: String = ""
//    var results = 0, page: Int = 0
//    var version: String = ""
//
//    required convenience public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: InfoKeys.self)
//        self.seed = try container.decodeIfPresent(String.self, forKey: .seed)!
//        self.results = try container.decodeIfPresent(Int.self, forKey: .results)!
//        self.page = try container.decodeIfPresent(Int.self, forKey: .page)!
//        self.version = try container.decodeIfPresent(String.self, forKey: .version)!
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: InfoKeys.self)
//        try container.encode(seed, forKey: .seed)
//        try container.encode(results, forKey: .results)
//        try container.encode(page, forKey: .page)
//        try container.encode(version, forKey: .version)
//    }
//}

// MARK: - DigiTinderUserModel
/*@objcMembers class DigiTinderUserModel: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case gender = "gender"
        case name = "name"
        case location = "location"
        case email = "email"
        case phone = "phone"
        case cell = "cell"
        case nat = "nat"
        case login = "login"
        case dob = "dob"
        case registered = "registered"
        case id = "id"
        case picture = "picture"
    }

    // MARK: - Core Data Managed Object
    @NSManaged var gender: String?
    @NSManaged var name: Name?
    @NSManaged var location: Location?
    @NSManaged var email, phone, cell, nat: String?
    @NSManaged var login: Login?
    @NSManaged var dob, registered: Dob?
    @NSManaged var id: ID?
    @NSManaged var picture: Picture?
    
    // MARK: Decodable
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "DigiTinderUser",
                                                    in: managedObjectContext) else {
            fatalError("Failed to decode User")
        }

        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
        self.name = try container.decodeIfPresent(Name.self, forKey: .name)
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.cell = try container.decodeIfPresent(String.self, forKey: .cell)
        self.nat = try container.decodeIfPresent(String.self, forKey: .nat)
        self.login = try container.decodeIfPresent(Login.self, forKey: .login)
        self.dob = try container.decodeIfPresent(Dob.self, forKey: .dob)
        self.registered = try container.decodeIfPresent(Dob.self, forKey: .registered)
        self.id = try container.decodeIfPresent(ID.self, forKey: .id)
        self.picture = try container.decodeIfPresent(Picture.self, forKey: .picture)
        
    }

    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gender, forKey: .gender)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(phone, forKey: .phone)
        try container.encode(cell, forKey: .cell)
        try container.encode(nat, forKey: .nat)
        try container.encode(login, forKey: .login)
        try container.encode(dob, forKey: .dob)
        try container.encode(registered, forKey: .registered)
        try container.encode(registered, forKey: .id)
        try container.encode(registered, forKey: .picture)
    }
}

// MARK: - Name
@objcMembers class Name: NSManagedObject, Codable {
    enum NameKeys: String, CodingKey {
        case title = "title"
        case first = "first"
        case last = "last"
    }
    
    @NSManaged var title: String?
    @NSManaged var first: String?
    @NSManaged var last: String?
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Name",
                                                    in: managedObjectContext) else {
            fatalError("Failed to decode User")
        }

        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: NameKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.first = try container.decodeIfPresent(String.self, forKey: .first)
        self.last = try container.decodeIfPresent(String.self, forKey: .last)
    }

    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NameKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(first, forKey: .first)
        try container.encode(last, forKey: .last)
    }
}

// MARK: - Location
@objcMembers class Location: NSManagedObject, Codable {
    enum LocationKeys: String, CodingKey {
        case street = "street"
        case city = "city"
        case state = "state"
        case country = "country"
        case postcode = "postcode"
        case coordinates = "coordinates"
        case timezone = "timezone"
    }
    
    @NSManaged var street: Street
    @NSManaged var city, state, country: String
    @NSManaged var postcode: Int
    @NSManaged var coordinates: Coordinates
    @NSManaged var timezone: Timezone

    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Name",
                                                    in: managedObjectContext) else {
            fatalError("Failed to decode User")
        }

        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: LocationKeys.self)
        self.street = try container.decodeIfPresent(Street.self, forKey: .street)!
        self.city = try container.decodeIfPresent(String.self, forKey: .city)!
        self.state = try container.decodeIfPresent(String.self, forKey: .state)!
        self.country = try container.decodeIfPresent(String.self, forKey: .country)!
        self.postcode = try container.decodeIfPresent(Int.self, forKey: .postcode)!
        self.coordinates = try container.decodeIfPresent(Coordinates.self, forKey: .coordinates)!
        self.timezone = try container.decodeIfPresent(Timezone.self, forKey: .timezone)!
    }

    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: LocationKeys.self)
        try container.encode(street, forKey: .street)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(country, forKey: .country)
        try container.encode(postcode, forKey: .postcode)
        try container.encode(coordinates, forKey: .coordinates)
        try container.encode(timezone, forKey: .timezone)
    }
}

// MARK: - Street
@objcMembers class Street: NSManagedObject, Codable {
    enum StreetKeys: String, CodingKey {
        case number = "number"
        case name = "name"
    }
    
    @NSManaged var number: String?
    @NSManaged var name: String?

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StreetKeys.self)
        self.number = try container.decodeIfPresent(String.self, forKey: .number)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
    }
    
    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StreetKeys.self)
        try container.encode(number, forKey: .number)
        try container.encode(name, forKey: .name)
    }
}

// MARK: - Dob
@objcMembers class Dob: NSManagedObject, Codable {
    enum DobKeys: String, CodingKey {
        case date = "date"
        case age = "age"
    }
    
    @NSManaged var date: String
    @NSManaged var age: Int

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DobKeys.self)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)!
        self.age = try container.decodeIfPresent(Int.self, forKey: .age)!
    }
    
    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DobKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(age, forKey: .age)
    }
}

// MARK: - ID
@objcMembers class ID: NSManagedObject, Codable {
    enum IDKeys: String, CodingKey {
        case name = "name"
        case value = "value"
    }
    
    @NSManaged var name: String
    @NSManaged var value: String?

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: IDKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)!
        self.value = try container.decodeIfPresent(String.self, forKey: .value)!
    }
    
    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: IDKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(value, forKey: .value)
    }
}

// MARK: - Coordinates
@objcMembers class Coordinates: NSManagedObject, Codable {
    enum CoordinateKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    @NSManaged var latitude, longitude: String

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CoordinateKeys.self)
        self.latitude = try container.decodeIfPresent(String.self, forKey: .latitude)!
        self.longitude = try container.decodeIfPresent(String.self, forKey: .longitude)!
    }
    
    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoordinateKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}

// MARK: - Timezone
@objcMembers class Timezone: NSManagedObject, Codable {
    enum TimezoneKeys: String, CodingKey {
        case offset = "offset"
        case timezone = "timezoneDescription"
    }
    
    @NSManaged var offset, timezone: String

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TimezoneKeys.self)
        self.offset = try container.decodeIfPresent(String.self, forKey: .offset)!
        self.timezone = try container.decodeIfPresent(String.self, forKey: .timezone)!
    }
    
    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TimezoneKeys.self)
        try container.encode(offset, forKey: .offset)
        try container.encode(timezone, forKey: .timezone)
    }
}

// MARK: - Login
@objcMembers class Login: NSManagedObject, Codable {
    enum LoginKeys: String, CodingKey {
        case uuid = "uuid"
        
        case username = "username"
        case password = "password"
        
        case salt = "salt"
        case md5 = "md5"
        case sha1 = "sha1"
        case sha256 = "sha256"
    }
    
    @NSManaged var uuid: String
    @NSManaged var username, password: String
    @NSManaged var salt, md5, sha1, sha256: String

    required convenience init(from decoder: Decoder) throws {
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: LoginKeys.self)
        
        self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid)!
        
        self.username = try container.decodeIfPresent(String.self, forKey: .username)!
        self.password = try container.decodeIfPresent(String.self, forKey: .password)!
        
        self.salt = try container.decodeIfPresent(String.self, forKey: .salt)!
        self.md5 = try container.decodeIfPresent(String.self, forKey: .md5)!
        self.sha1 = try container.decodeIfPresent(String.self, forKey: .sha1)!
        self.sha256 = try container.decodeIfPresent(String.self, forKey: .sha256)!
    }
    
    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: LoginKeys.self)
        try container.encode(uuid, forKey: .uuid)
        
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        
        try container.encode(salt, forKey: .salt)
        try container.encode(md5, forKey: .md5)
        try container.encode(sha1, forKey: .sha1)
        try container.encode(sha256, forKey: .sha256)
    }
}

// MARK: - Picture
@objcMembers class Picture: NSManagedObject, Codable {
    enum PictureKeys: String, CodingKey {
        case large = "large"
        case medium = "medium"
        case thumbnail = "thumbnail"
    }
    
    @NSManaged var large, medium, thumbnail: String

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PictureKeys.self)
        self.large = try container.decodeIfPresent(String.self, forKey: .large)!
        self.medium = try container.decodeIfPresent(String.self, forKey: .medium)!
        self.thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)!
    }
    
    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PictureKeys.self)
        try container.encode(large, forKey: .large)
        try container.encode(medium, forKey: .medium)
        try container.encode(thumbnail, forKey: .thumbnail)
    }
}*/

// MARK: - Enums
enum Postcode {
    case integer(Int)
    case string(String)
}

enum Title {
    case mademoiselle
    case miss
    case mr
    case mrs
    case ms
}
