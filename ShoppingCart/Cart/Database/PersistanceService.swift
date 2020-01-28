//
//  File.swift
//  CoreData_Manually
//
//  Created by Waqar Ahmed on 17/05/2018.
//  Copyright © 2018 MilanConsult GmbH. All rights reserveWaqar
//

import Foundation
import CoreData

struct App {
    static let name = "ShoppingCartDB"
    static let databaseName = String(format: "%@.sqlite", App.name)

}

class PersistanceService{
    
    // MARK: - Core Data stack
    public static let shared = PersistanceService()
    var completionHanler : (() -> ())?
    
    private init(){
        
       let newbackgroundContext = persistentContainer.newBackgroundContext()
       newbackgroundContext.name = "ShoppingCartDBBackgroundContext"
       newbackgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
       newbackgroundContext.automaticallyMergesChangesFromParent = true
       backgroundContext =  newbackgroundContext
           
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }

    
    var handler : ((Bool) -> Void)?
    

    var context : NSManagedObjectContext{
        return persistentContainer.viewContext
    }

    
    var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        //        ********************************** Below NSPersistentContainer should be your project name ***************
        let container = NSPersistentContainer(name: App.name)
        
        /*initialize a fixed DB Path*/
        let storeURL = try! FileManager
            .default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(App.databaseName)
        print(storeURL)
        
        /*add necessary support for migration*/
        let description = NSPersistentStoreDescription(url: storeURL)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions =  [description]
        /*add necessary support for migration*/
        
        //        ****************  Following line is used to avoid duplication in database + add constraints in coredata class against certain key
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is lockeWaqar
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print("PersistanceService: Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var backgroundContext: NSManagedObjectContext!
    
    
    // MARK: - Core Data Saving support
    
    func saveContext (completion : @escaping () -> ()) {
        
        self.completionHanler = completion
    
        DispatchQueue.main.async {
            let context = self.persistentContainer.viewContext
            
            if context.hasChanges {
                do {
                    try context.save()
                    print("PersistanceService: Data saved successfully!")
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    print("PersistanceService: Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func saveBackgroundContext(completion : @escaping () -> ()) {
        self.completionHanler = completion
        
        let backgroundContext = PersistanceService.shared.backgroundContext
        // Do some core data processing here
//        backgroundContext.performAndWait {
            
        if backgroundContext!.hasChanges {
                do {
                    try backgroundContext!.save()
                    print("PersistanceService: In background context Data saved successfully!")
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    print("PersistanceService:  In background context Unresolved error \(nserror), \(nserror.userInfo)")
                   
                }
            }
//        }
    }
    
    @objc
    func contextDidSave(_ notification: Notification) {
            
    //        print(notification)
            if let handler = self.completionHanler {
                handler()
            }
            
        }

    
    // MARK: - Core Data Single Delete
//
//    func deleteUser (item: Item) {
//            let context = persistentContainer.viewContext
//            context.delete(item)
//            if context.hasChanges {
//                do {
//                    try context.save()
//                    print("Data saves successfully!")
//                } catch {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    let nserror = error as NSError
//                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//                }
//            }
//    }
    
    // MARK: - Core Data Single Delete
    
    static func deleteAllItems () {
        //        Option 1  **************************
        //        let context = persistentContainer.viewContext
        //        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Item.fetchRequest())
        //        do{
        //            try context.execute(deleteRequest)
        //        }
        //        catch{
        //
        //        }
        //        ******************  Option 2 **************
        //        context.delete(item)
        //        if context.hasChanges {
        //            do {
        //                try context.save()
        //                print("Data saves successfully!")
        //            } catch {
        //                // Replace this implementation with code to handle the error appropriately.
        //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //                let nserror = error as NSError
        //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        //            }
        //        }
    }
    
}
