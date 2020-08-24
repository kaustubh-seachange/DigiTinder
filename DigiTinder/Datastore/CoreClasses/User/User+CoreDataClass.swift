//
//  User+CoreDataClass.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, Codable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(gender ?? "blank", forKey: .gender)
            try container.encode(email ?? "blank", forKey: .email)
            try container.encode(phone ?? "blank", forKey: .phone)
            try container.encode(cell ?? "blank", forKey: .cell)
            try container.encode(nat ?? "blank", forKey: .nat)
            
            try container.encode(hasName, forKey: .name)
            try container.encode(isLocatedAt, forKey: .location)
            try container.encode(loginInfo, forKey: .login)
            try container.encode(hasDob, forKey: .dob)
            try container.encode(hasID, forKey: .id)
            try container.encode(hasPicture, forKey: .picture)
        } catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
        let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "User",
                                                in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            gender = try container.decode(String.self, forKey: .gender)
            email = try container.decode(String.self, forKey: .email)
            phone = try container.decode(String.self, forKey: .phone)
            cell = try container.decode(String.self, forKey: .cell)
            nat = try container.decode(String.self, forKey: .nat)
            
            hasName = try container.decode(Name.self, forKey: .name)
            isLocatedAt = try container.decode(Location.self, forKey: .location)
            loginInfo = try container.decode(Login.self, forKey: .login)
            hasDob = try container.decode(Dob.self, forKey: .dob)
            hasID = try container.decode(ID.self, forKey: .id)
            hasPicture = try container.decode(Picture.self, forKey: .picture)
        } catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case gender = "gender"
        case email = "email"
        case phone = "phone"
        case cell = "cell"
        case nat = "nat"

        case name = "name"
        case location = "location"
        case login = "login"
        case dob = "dob"
        case registered = "registered"
        case id = "id"
        case picture = "picture"
    }
    
}
