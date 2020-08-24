//
//  Timezone+CoreDataClass.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData

@objc(Timezone)
public class Timezone: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(offset ?? "blank", forKey: .offset)
            try container.encode(timezoneDescription ?? "blank", forKey: .timezoneDescription)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
        let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "Timezone",
                                                in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            offset = try values.decode(String.self, forKey: .offset)
            timezoneDescription = try values.decode(String.self, forKey: .timezoneDescription)
        } catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case offset = "offset"
        case timezoneDescription = "timezoneDescription"
    }
}
