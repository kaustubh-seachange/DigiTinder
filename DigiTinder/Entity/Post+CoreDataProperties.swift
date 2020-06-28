//
//  Post+CoreDataProperties.swift
//  DigiTinder
//
//  Created by Kaustubh on 26/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import CoreData

extension DigiTinder {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DigiTinder> {
        return NSFetchRequest<DigiTinder>(entityName: "DigiTinder");
    }
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var picture: String?
    @NSManaged public var location: String?
    @NSManaged public var id: Int32
}
