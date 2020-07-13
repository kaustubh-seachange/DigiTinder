//
//  CoreDataStore.swift
//  DigiTinder
//
//  Created by Kaustubh on 26/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataStore: NSObject {
    
    static let sharedInstance = CoreDataStore()
    private override init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DigiTinder")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}



extension CoreDataStore {
    func applicationDocumentsDirectory() {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "yo.BlogReaderApp" in the application's documents directory.
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}

extension CoreDataStore {
    func favouriteProfiles() -> [Any] {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TinderUser>(entityName: "TinderUser")
        let sortDescriptor1 = NSSortDescriptor(key: "ssn", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "username", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        do {
            let managedObjects = try managedObjectContext.fetch(fetchRequest)
            let viewModelObjects = self.createDigiTinderViewModel(moArray: managedObjects)
            return viewModelObjects as! [Any]
        } catch let error {
            print(error)
            return []
        }
    }
    
    func createDigiTinderViewModel(moArray: [NSManagedObject]) -> Any {
        var array: [TinderUserResponseModel] = []
        for item in moArray {
            var dict: [String: String] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value as? String
                }
            }
            let aObj = self.creteModel(dict: dict)
            if aObj != nil {
                array.append((aObj as TinderUserResponseModel?)!)
            }
            else {
                print("skipped...")
            }
            
        }
        return array
    }
    
    func creteModel(dict: Dictionary<String, String>) -> TinderUserResponseModel? {
        let nameModel = Name.init(title: dict["title"]!,
                                  first: dict["first"]!,
                                  last: dict["last"]!)
        let locationModel = Location.init(street: dict["street"]!,
                                          city: dict["city"]!,
                                          state: dict["state"]!,
                                          zip: dict["zip"]!)
        let userModel = TinderUserResponseModel.init(name: nameModel,
                                                           location: locationModel,
                                                           gender: dict["gender"]!,
                                                           email: dict["email"]!,
                                                           username: dict["username"]!,
                                                           password: dict["password"]!,
                                                           salt: dict["salt"]!,
                                                           md5: dict["md5"]!,
                                                           sha1: dict["sha1"]!,
                                                           sha256: dict["sha256"]!,
                                                           registered: dict["registered"]!,
                                                           phone: dict["phone"]!,
                                                           cell: dict["cell"]!,
                                                           ssn: dict["ssn"]!,
                                                           picture: dict["picture"]!,
                                                           dob: dict["dob"]!)

        return userModel
    }
    
}

extension CoreDataStore {
    func createTinderEntity(user: TinderUserResponseModel) -> NSManagedObject? {
        let context = CoreDataStore.sharedInstance.persistentContainer.viewContext
        if let tinderUserEntity = NSEntityDescription.insertNewObject(forEntityName: "TinderUser", into: context) as? TinderUser {
            tinderUserEntity.title = user.name.title
            tinderUserEntity.first = user.name.first
            tinderUserEntity.last = user.name.last
            
            tinderUserEntity.street = user.location.street
            tinderUserEntity.city = user.location.city
            tinderUserEntity.state = user.location.state
            tinderUserEntity.zip = user.location.zip

            tinderUserEntity.ssn = user.ssn
            tinderUserEntity.gender = user.gender
            tinderUserEntity.dob = user.dob
            tinderUserEntity.picture = user.picture
            tinderUserEntity.email = user.email
            tinderUserEntity.phone = user.phone
            tinderUserEntity.cell = user.cell

            
            tinderUserEntity.registered = user.registered
            let secureInfo = DTSecureInfo()
            tinderUserEntity.username = secureInfo.secureName(using: user.md5,
                                                              name: user.username)
            tinderUserEntity.password = secureInfo.securePass(using: user.salt,
                                                              name: user.username,
                                                              pass: user.password)
            // Do we need to stroe this keys?
            tinderUserEntity.md5 = user.md5
            tinderUserEntity.salt = user.salt
            tinderUserEntity.sha1 = user.sha1
            tinderUserEntity.sha256 = user.sha256
            
            return tinderUserEntity
        }
        return nil
    }
    
    func clearData() {
        do {
            let context = CoreDataStore.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: TinderUser.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStore.sharedInstance.saveContext()
            } catch let error {
                print("error_delete_ops: \(error.localizedDescription)")
            }
        }
    }
}