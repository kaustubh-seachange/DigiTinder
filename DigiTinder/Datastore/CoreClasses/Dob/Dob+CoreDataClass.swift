//
//  Dob+CoreDataClass.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData

@objc(Dob)
public class Dob: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(date, forKey: .date)
            try container.encode(age, forKey: .age)
        } catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
        let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "Dob",
                                                in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let formatter = ISO8601DateFormatter()
            let tDate = try container.decode(String.self, forKey: .date)
            date = formatter.date(from: tDate) ?? Date()
            age = try container.decode(Int16.self, forKey: .age)
        } catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case age = "age"
    }
}
