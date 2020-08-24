//
//  Name+CoreDataProperties.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData


extension Name {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Name> {
        return NSFetchRequest<Name>(entityName: "Name")
    }

    @NSManaged public var last: String?
    @NSManaged public var first: String?
    @NSManaged public var title: String?

}
