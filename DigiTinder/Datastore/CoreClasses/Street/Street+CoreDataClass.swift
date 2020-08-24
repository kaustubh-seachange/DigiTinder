//
//  Street+CoreDataClass.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData

@objc(Street)
public class Street: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(name, forKey: .name)
            try container.encode(number, forKey: .number)
        } catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
        let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "Street",
                                                in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            name = try container.decode(String.self, forKey: .name)
            let tNumber = try container.decode(Int32.self, forKey: .number)
            number = "\(tNumber)"
        } catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case number = "number"
    }
}
