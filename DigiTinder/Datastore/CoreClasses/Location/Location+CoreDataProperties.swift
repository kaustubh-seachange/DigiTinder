//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var country: String?
    @NSManaged public var state: String?
    @NSManaged public var city: String?
    @NSManaged public var postcode: String?
    
    @NSManaged public var onStreet: Street?
    @NSManaged public var atCoordinates: Coordinates?
    @NSManaged public var atTimezone: Timezone?

}
