//
//  Timezone+CoreDataProperties.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData


extension Timezone {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timezone> {
        return NSFetchRequest<Timezone>(entityName: "Timezone")
    }

    @NSManaged public var offset: String?
    @NSManaged public var timezoneDescription: String?

}
