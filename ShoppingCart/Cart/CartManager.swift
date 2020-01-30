//
//  Cart.swift
//  ShoppingCart
//
//  Created by D. on 2018-06-05.
//  Copyright © 2020 Waqar. All rights reserved.
//

import Foundation

public struct CartTotal {
    
    var price : Float
    var quantity : Int
    
}

public class CartManager {
    
    private(set) var items : [CartItem] = []
    let databaseManager : DatabaseManager!
    public static let shared = CartManager()
    public static let UPDATE_TRIGGER = "Update_List"
    private init() {
        databaseManager = DatabaseManager()
        items = databaseManager.getCartProducts()
    }
}

extension CartManager {
    
    var total: Float {
        get { return items.reduce(0.0) { value, item in
            value + item.getTotal()
            }
        }
    }
    
    var totalQuantity : Int {
        get { return items.count }
    }
 
    func updateItem(product: Saleable) {

        if let item = databaseManager.get(cartProduct: product) {
            if(product.getQuantity() == 0){
                if databaseManager.delete(cartItem: product){
                    
                }
                
            }else{
                item.quantity = product.getQuantity()
                if databaseManager.save() {
                    print("Item updated")
                }
            }
            
        }
        else{
            if(product.getQuantity() > 0){
                _ = CartItem(product: product)
                if databaseManager.save() {
                    print("New item added")
                }
                else {
                    print("Error on save in database")
                }
            }
        }
        
        notifyDataSet()
    }
    
    public func notifyDataSet(){
        DispatchQueue.global().async {
            self.items = self.databaseManager.getCartProducts()
            DispatchQueue.main.async {
                let total = CartTotal(price: self.total, quantity: self.totalQuantity)
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: CartManager.UPDATE_TRIGGER), object: total)
            }
        }
    }
    
    func mapWithCart<T: Saleable>(saleable : [T]) -> [T]{
        
        var products = saleable as [Saleable]
        
        let queue = DispatchQueue(label: "com.cart.myprivatecart", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 0)
        
        queue.async {
            self.items.forEach { cartItem in
                if let productIndex = products.firstIndex(where: {$0.getId() == cartItem.getId()}) {
                    products[productIndex].quantity = cartItem.quantity
                }
            }
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)

        return products as! [T]
    }
    
}
