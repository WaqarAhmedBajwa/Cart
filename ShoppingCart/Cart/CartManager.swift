//
//  Cart.swift
//  ShoppingCart
//
//  Created by Waqar on 2010-01-27.
//  Copyright © 2020 Waqar All rights reserve
//

import Foundation
import Combine

extension Notification.Name {
    static let cartChanges = Notification.Name("Update_List")
    static let total = Notification.Name("TOTAL_AMOUNT")
}

//struct CartTotal {
//    
//    var price : Float
//    var quantity : Int
//    
//}


class CartManager {
    
    private(set) var items : [CartItem] = [] {
        didSet{
            setup()
        }
    }
    let databaseManager : DatabaseManager!
    public static let shared = CartManager()
    
    private init() {
        
        databaseManager = DatabaseManager()
        notifyDataSet()
        getProductsFromDatabase()
        
    }
//    @available(iOS 13.0, *)
    var publisher: Publishers.Map<NotificationCenter.Publisher, String?>!
    var publisherForTotal: Publishers.Map<NotificationCenter.Publisher, String?>!
}

extension CartManager {
    
    private var total: Float {
        get { return items.reduce(0.0) { value, item in
            value + item.getTotal()
            }
        }
    }
    
    private var totalQuantity : Int {
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
        getProductsFromDatabase()
        
    }
    
    private func getProductsFromDatabase(){
        items = self.databaseManager.getCartProducts()
    }
    
    private func notifyDataSet(){
        
        publisher = NotificationCenter.Publisher(center: .default,
                                                 name: .cartChanges,
                                                 object: nil)
            .map { (notification) -> String in
                guard let totalItems = notification.object as? [CartItem] else {
                    return "Checkout 0"
                }
                return String("Checkout (\(totalItems.count))")
        }
        
        publisherForTotal = NotificationCenter.Publisher(center: .default,
                                                 name: .total,
                                                 object: nil)
            .map { (notification) -> String in
                guard let totalAmount = notification.object as? Float else {
                    return "0.0"
                }
                return String(totalAmount)
        }
    }
    
    
    func mapWithCart<T: Saleable>(saleable : [T]) -> [T]{
        
        var products = saleable as [Saleable]
        
        items.forEach { cartItem in
            if let productIndex = products.firstIndex(where: {$0.getId() == cartItem.getId()}) {
                products[productIndex].quantity = cartItem.quantity
            }
        }
        return products as! [T]
    }
    
    func setup()  {
        
        NotificationCenter.default.post(name: .cartChanges, object: items)
        NotificationCenter.default.post(name: .total, object: total)
    }
}
