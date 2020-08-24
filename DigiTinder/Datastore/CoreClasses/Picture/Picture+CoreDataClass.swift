//
//  Picture+CoreDataClass.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData

@objc(Picture)
public class Picture: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(thumbnail ?? "blank", forKey: .thumbnail)
            try container.encode(large ?? "blank", forKey: .large)
            try container.encode(medium ?? "blank", forKey: .medium)
        } catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Picture",
                                                    in: managedObjectContext)
            else {
                fatalError("decode failure")
        }

        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            thumbnail = try container.decode(String.self, forKey: .thumbnail)
            large = try container.decode(String.self, forKey: .large)
            medium = try container.decode(String.self, forKey: .medium)
        } catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }

    enum CodingKeys: String, CodingKey {
        case thumbnail = "thumbnail"
        case large = "large"
        case medium = "medium"
    }
}
