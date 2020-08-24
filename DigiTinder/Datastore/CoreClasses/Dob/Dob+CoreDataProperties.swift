//
//  Dob+CoreDataProperties.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData


extension Dob {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dob> {
        return NSFetchRequest<Dob>(entityName: "Dob")
    }

    @NSManaged public var date: Date?
    @NSManaged public var age: Int16

}
