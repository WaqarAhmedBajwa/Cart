//
//  File.swift
//  CoreData_Manually
//
//  Created by Waqar Ahmed on 17/05/2018.
//  Copyright © 2018 MilanConsult GmbH. All rights reserved.
//

import Foundation
import CoreData

struct App {
    static let name = "ShoppingCartDB"  //Model name
    static let databaseName = String(format: "%@.sqlite", App.name)
    static let identifier: String  = "org.cocoapods.Cart"       //Framework bundle ID
            
}

class PersistanceService{
    
    
    
    
    public static let shared = PersistanceService()
    var completionHanler : (() -> ())?
    var backgroundContext: NSManagedObjectContext!
    
    private init(){
        
        let newbackgroundContext = persistentContainer.newBackgroundContext()
        newbackgroundContext.name = "ShoppingCartDBBackgroundContext"
        newbackgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext =  newbackgroundContext
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    var context : NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: App.name)
        
        /*
         let fileManager = FileManager.default
                guard let  currentPath = URL(string: String(format: "/%@",App.databaseName)) else { return container }
                print(currentPath)
         */
//        let messageKitBundle = Bundle(identifier: App.identifier)
//        let modelURL = messageKitBundle!.url(forResource: App.name, withExtension: "momd")!
//        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
//        
//        
//        let container = NSPersistentContainer(name: App.name, managedObjectModel: managedObjectModel!)
        
        
        let storeURL = try! FileManager
            .default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(App.databaseName)
        print(storeURL)
        
        let description = NSPersistentStoreDescription(url: storeURL)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions =  [description]
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                
                print("PersistanceService: Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
    func saveContext (completion : @escaping () -> ()) {
        
        self.completionHanler = completion
        
        DispatchQueue.main.async {
            let context = self.persistentContainer.viewContext
            
            if context.hasChanges {
                do {
                    try context.save()
                    print("PersistanceService: Data saved successfully!")
                } catch {
                    
                    let nserror = error as NSError
                    print("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func saveBackgroundContext(completion : @escaping () -> ()) {
        self.completionHanler = completion
        
        let backgroundContext = PersistanceService.shared.backgroundContext
        
        if backgroundContext!.hasChanges {
            do {
                try backgroundContext!.save()
                print("PersistanceService: In background context Data saved successfully!")
            } catch {
                let nserror = error as NSError
                print("PersistanceService:  In background context Unresolved error \(nserror), \(nserror.userInfo)")
                
            }
        }
    }
    
    @objc
    func contextDidSave(_ notification: Notification) {
        if let handler = self.completionHanler {
            handler()
        }
    }
}
