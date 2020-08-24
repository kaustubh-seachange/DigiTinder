//
//  ID+CoreDataClass.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData

@objc(ID)
public class ID: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(name, forKey: .name)
            try container.encode(value, forKey: .value)
        } catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
        let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "ID",
                                                in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.name = try container.decode(String.self, forKey: .name)
            let tValue = try container.decodeIfPresent(String.self, forKey: .value)
            self.value = (tValue!.count > 0) ? tValue : ""
        } catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case value = "value"
    }
}
