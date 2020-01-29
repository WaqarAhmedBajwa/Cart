//
//  DatabaseManager.swift
//  ShoppingCart
//
//  Created by Waqar Ahmed on 27/01/2020.
//  Copyright © 2020 Waqar. All rights reserved.
//

import Foundation
import CoreData


struct DatabaseManager {
    
    func getCartProducts() -> [CartItem] {

        var products = [CartItem]()

        let fetchRequest : NSFetchRequest<CartItem> = CartItem.fetchRequest()

        do
        {
            products =  try PersistanceService.shared.backgroundContext.fetch(fetchRequest)

        }
        catch
        {
            print("DatabaseManager: Error on fetching Cart items from core data")

        }
        return products
    }
    
    func get(cartProduct product : Saleable) -> CartItem? {
            
        var cartItems = [CartItem]()
            
            let fetchRequest : NSFetchRequest<CartItem> = CartItem.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", product.getId())
            fetchRequest.predicate = predicate
            
            do
            {
                cartItems =  try PersistanceService.shared.backgroundContext.fetch(fetchRequest)
            }
            catch
            {
                print("ContactDataManager: Error on fetching Contacts from core data")
            }
            
            return  cartItems.first
        }
    
    func deleteAllCartItems() -> Bool {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try PersistanceService.shared.backgroundContext.execute(deleteRequest)
            try PersistanceService.shared.backgroundContext.save()
            return true
        }
        catch{
            print("DatabaseManager: Error on deleting Cart item from core data")
            return false
        }
    }
    
    func delete(cartItem :Saleable ) -> Bool {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        let predicate = NSPredicate(format: "id == %@", cartItem.getId())
        deleteFetch.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try PersistanceService.shared.backgroundContext.execute(deleteRequest)
            try PersistanceService.shared.backgroundContext.save()
            return true
        }
        catch{
            print("DatabaseManager: Error on deleting Cart item from core data")
            return false
        }
    }
    
    
    func save() -> Bool {
        
        let semaphore = DispatchSemaphore(value: 0)
        PersistanceService.shared.saveBackgroundContext {
        
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)
        return true
    }
    
}

