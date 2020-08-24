//
//  Street+CoreDataProperties.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData


extension Street {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Street> {
        return NSFetchRequest<Street>(entityName: "Street")
    }

    @NSManaged public var name: String?
    @NSManaged public var number: String?

}
