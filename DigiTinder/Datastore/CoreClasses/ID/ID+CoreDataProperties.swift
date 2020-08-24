//
//  ID+CoreDataProperties.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData


extension ID {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ID> {
        return NSFetchRequest<ID>(entityName: "ID")
    }

    @NSManaged public var name: String?
    @NSManaged public var value: String?

}
