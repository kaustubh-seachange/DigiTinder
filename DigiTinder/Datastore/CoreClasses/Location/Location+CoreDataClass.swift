//
//  Location+CoreDataClass.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(city, forKey: .city)
            try container.encode(state, forKey: .state)
            try container.encode(country, forKey: .country)
            try container.encode(postcode, forKey: .postcode)
            
            try container.encode(onStreet, forKey: .street)
            try container.encode(atCoordinates, forKey: .coordinates)
            try container.encode(atTimezone, forKey: .timezone)
        }
        catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
        let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "Location",
                                                in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            city = try container.decode(String.self, forKey: .city)
            state = try container.decode(String.self, forKey: .state)
            country = try container.decode(String.self, forKey: .country)
            
            let tPostcode = try container.decode(Int32.self, forKey: .postcode)
            postcode = "\(tPostcode)"
            //postcode = try container.decode(String.self, forKey: .postcode)
            
            onStreet = try container.decode(Street.self, forKey: .street)
            atCoordinates = try container.decode(Coordinates.self, forKey: .coordinates)
            atTimezone = try container.decode(Timezone.self, forKey: .timezone)
        } catch {
            print("{\(#function):\(#line)} :) \(error)")
        }
    }

    enum CodingKeys: String, CodingKey {
        case city = "city"
        case state = "state"
        case country = "country"
        case postcode = "postcode"
        
        case street = "street"
        case coordinates = "coordinates"
        case timezone = "timezone"
    }
}
