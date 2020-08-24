//
//  User+CoreDataProperties.swift
//  
//
//  Created by Kaustubh on 07/08/20.
//
//

import Foundation
import CoreData

extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var gender: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var cell: String?
    @NSManaged public var nat: String?
    
    @NSManaged public var hasName: Name?
    @NSManaged public var isLocatedAt: Location?
    @NSManaged public var loginInfo: Login?
    @NSManaged public var hasDob: Dob?
    @NSManaged public var hasPicture: Picture?
    @NSManaged public var hasID: ID?

}
