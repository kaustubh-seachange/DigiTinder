//
//  Login+CoreDataClass.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData

@objc(Login)
public class Login: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(uuid, forKey: .uuid)
            
            try container.encode(username, forKey: .username)
            try container.encode(password, forKey: .password)
            
            try container.encode(salt, forKey: .salt)
            try container.encode(md5, forKey: .md5)
            try container.encode(sha1, forKey: .sha1)
            try container.encode(sha256, forKey: .sha256)
        }
        catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
        let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "Login",
                                                in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            uuid = try container.decode(String.self, forKey: .uuid)
            
            username = try container.decode(String.self, forKey: .username)
            password = try container.decode(String.self, forKey: .password)
            
            salt = try container.decode(String.self, forKey: .salt)
            md5 = try container.decode(String.self, forKey: .md5)
            sha1 = try container.decode(String.self, forKey: .sha1)
            sha256 = try container.decode(String.self, forKey: .sha256)
        }
        catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        
        case username = "username"
        case password = "password"
        
        case salt = "salt"
        case md5 = "md5"
        case sha1 = "sha1"
        case sha256 = "sha256"
    }
}
