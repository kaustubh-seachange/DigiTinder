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
    static let UserEntityName = "User"
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
    
    func applicationDocumentsDirectory() {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "yo.BlogReaderApp" in the application's documents directory.
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            self.loggerMin(url.absoluteString)
        }
    }
}

extension CoreDataStore {
    func favouriteProfiles() -> [Any] {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        let sortDescriptor1 = NSSortDescriptor(key: "email", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "phone", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        do {
            let managedObjects = try managedObjectContext.fetch(fetchRequest)
            let viewModelObjects = self.createDigiTinderViewModel(moArray: managedObjects)
            return viewModelObjects as! [Any]
        } catch let error {
            self.loggerMin(String(describing: error))
            return []
        }
    }
    
    func createDigiTinderViewModel(moArray: [NSManagedObject]) -> Any {
        let array: [User] = []
        for item in moArray {
            var dict: [String: String] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value as? String
                }
            }
//            let aObj = self.createModel(dict: dict)
//            if aObj != nil {
//                array.append((aObj as User?)!)
//            }
//            else {
//                self.loggerMin("skipped...")
//            }
            
        }
        return array
    }
    
//    func createModel(dict: Dictionary<String, String>) -> User? {
//        let userModel: User
//        
//        return userModel
//    }
}

extension CoreDataStore {
    func findExistingUser(user: User) -> Bool {
        let context = CoreDataStore.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: User.self))
        fetchRequest.predicate = NSPredicate(format: "email == %@ && phone == %@", user.email!, user.phone!)
        do {
            let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
            if objects!.count > 0 {
                return true
            }
            else {
                return false
            }
        }
        catch {
            self.loggerMin("error executing fetch request: \(error)")
            return false
        }
    }
    
    func createTinderEntity(user: User) -> NSManagedObject? {
        let context = CoreDataStore.sharedInstance.persistentContainer.viewContext
        if let tinderUserEntity = NSEntityDescription.insertNewObject(forEntityName: "User",
                                                                      into: context) as? User {
//            tinderUserEntity.title = user.name.title
//            tinderUserEntity.first = user.name.first
//            tinderUserEntity.last = user.name.last
//
//            tinderUserEntity.street = user.location.street.name
//            tinderUserEntity.city = user.location.city
//            tinderUserEntity.state = user.location.state
//            tinderUserEntity.zip = user.location.street.name
//
//            tinderUserEntity.ssn = user.nat
//            tinderUserEntity.gender = user.gender
//            tinderUserEntity.dob = user.dob.date
//            tinderUserEntity.picture = user.picture.medium
//            tinderUserEntity.email = user.email
//            tinderUserEntity.phone = user.phone
//            tinderUserEntity.cell = user.cell
//
//
//            tinderUserEntity.registered = String(user.dob.age)
//            let secureInfo = DTSecureInfo()
//            tinderUserEntity.username = secureInfo.secureName(using: user.login.md5,
//                                                              name: user.login.username)
//            tinderUserEntity.password = secureInfo.securePass(using: user.login.salt,
//                                                              name: user.login.username,
//                                                              pass: user.login.password)
//            // Do we need to stroe this keys?
//            tinderUserEntity.md5 = user.login.md5
//            tinderUserEntity.salt = user.login.salt
//            tinderUserEntity.sha1 = user.login.sha1
//            tinderUserEntity.sha256 = user.login.sha256
            
            return tinderUserEntity
        }
        return nil
    }
    
    func clearData() {
        do {
            let context = CoreDataStore.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: User.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStore.sharedInstance.saveContext()
            } catch let error {
                self.loggerMin("error_delete_ops: \(error.localizedDescription)")
            }
        }
    }
    
    func removeTinderUser(user: User) -> Bool {
        let context = CoreDataStore.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: User.self))
        fetchRequest.predicate = NSPredicate(format: "email == %@ && phone == %@", user.email!, user.phone!)
        do {
            let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
            _ = objects.map{$0.map{context.delete($0)}}
            
            CoreDataStore.sharedInstance.saveContext()
            return true
        } catch let error {
            self.loggerMin("error while delete: \(error.localizedDescription)")
            return false
        }
    }
}
