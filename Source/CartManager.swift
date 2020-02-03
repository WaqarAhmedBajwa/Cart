//
//  Cart.swift
//  ShoppingCart
//
//  Created by D. on 2018-06-05.
//  Copyright © 2020 Waqar. All rights reserved.
//

import Foundation

public struct CartTotal {
    
    public var totalAmount : Float
    public var totalItems : Int
    
}

public class CartManager {
    
    public private(set) var items : [CartItem] = []
    let databaseManager : DatabaseManager!
    public static let shared = CartManager()
    public static let UPDATE_TRIGGER = "Update_List"
    
    private init() {
        
         _ = PersistanceService.shared
      
        databaseManager = DatabaseManager()
        items = databaseManager.getCartProducts()
    }
}

extension CartManager {
    
    public var total: Float {
        get { return items.reduce(0.0) { value, item in
            value + item.getTotal()
            }
        }
    }
    
    public var totalQuantity : Int {
        get { return items.count }
    }
 
    public func updateItem(saleable: Saleable) {

        if let item = databaseManager.get(cartProduct: saleable) {
            if(saleable.getQuantity() == 0){
                if databaseManager.delete(cartItem: saleable){
                    
                }
                
            }else{
                item.quantity = saleable.getQuantity()
                if databaseManager.save() {
                    print("CartManager: Item updated")
                }
            }
            
        }
        else{
            if(saleable.getQuantity() > 0){
                _ = CartItem(with: saleable)
                if databaseManager.save() {
                    print("CartManager: New item added")
                }
                else {
                    print("CartManager: Error on save in database")
                }
            }
        }
        
        notifyDataSet()
    }
    
    public func removeItem(saleable : Saleable) {
           if databaseManager.delete(cartItem: saleable){
               notifyDataSet()
           }
       }
    
    public func notifyDataSet(){
        DispatchQueue.global().async {
            self.items = self.databaseManager.getCartProducts()
            DispatchQueue.main.async {
                let total = CartTotal(totalAmount: self.total, totalItems: self.totalQuantity)
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: CartManager.UPDATE_TRIGGER), object: total)
            }
        }
    }
    
    public func mapWithCart<T: Saleable>(saleable : [T]) -> [T]{
        
        let products = saleable as [Saleable]
        
        let queue = DispatchQueue(label: "com.cart.myprivatecart", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 0)
        queue.async {
            for var product in products {
                if let cartItem = self.items.first(where: { product.getId() == $0.getId() }) {
                    product.quantity = cartItem.quantity
                }
                else{
                    product.quantity = 0
                }
                
            }
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)

        return products as! [T]
    }
    
}
