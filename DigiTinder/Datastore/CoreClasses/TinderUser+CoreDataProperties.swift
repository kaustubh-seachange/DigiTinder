//
//  TinderUser+CoreDataProperties.swift
//  
//
//  Created by Kaustubh on 12/07/20.
//
//

import Foundation
import CoreData

extension TinderUser {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TinderUser> {
        return NSFetchRequest<TinderUser>(entityName: "TinderUser")
    }
    @NSManaged public var first: String?
    @NSManaged public var last: String?
    @NSManaged public var title: String?
    
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var zip: String?
    @NSManaged public var street: String?
    
    @NSManaged public var gender: String?
    @NSManaged public var dob: String?
    @NSManaged public var phone: String?
    @NSManaged public var cell: String?
    @NSManaged public var email: String?
    @NSManaged public var picture: String?
    @NSManaged public var registered: String?
    @NSManaged public var ssn: String?
    
    @NSManaged public var username: String?
    @NSManaged public var password: String?
    
    @NSManaged public var salt: String?
    @NSManaged public var md5: String?
    @NSManaged public var sha1: String?
    @NSManaged public var sha256: String?
}
