//
//  Coordinates+CoreDataClass.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData

@objc(Coordinates)
public class Coordinates: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(latitude ?? "blank", forKey: .latitude)
            try container.encode(longitude ?? "blank", forKey: .longitude)
        } catch {
            print("error")
        }
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Coordinates",
                                                    in: managedObjectContext)
            else {
                fatalError("decode failure")
        }

        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            latitude = try values.decode(String.self, forKey: .latitude)
            longitude = try values.decode(String.self, forKey: .longitude)
        } catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }

    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
