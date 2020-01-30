//
//  CartItem+CoreDataProperties.swift
//  ShoppingCart
//
//  Created by Waqar Ahmed on 27/01/2020.
//  Copyright © 2020 Waqar. All rights reserved.
//
//

import Foundation
import CoreData


extension CartItem : Saleable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var totalItem: Int16
    @NSManaged public var price: Float
    private var subTotal : Float { get { return Float(quantity ?? 0) * price } }
    
    var quantity: Int? {
        get {
            Int(totalItem)
        }
        set {
            totalItem = Int16(newValue ?? 0)
        }
    }
    
    
    func getId() -> String {
        return id
    }
    
    func getName() -> String {
        return name
    }
    
    func getQuantity() -> Int {
        return Int(totalItem)
    }
    
    func getTotal() -> Float {
       return subTotal
    }
    
    func getPrice() -> Float {
        return price
    }
    
    
    convenience init(product: Saleable) {
        self.init(context: PersistanceService.shared.backgroundContext)
        self.id = product.getId()
        self.quantity = product.getQuantity()
        self.name = product.getName()
        self.price = product.getPrice()
       
    }
    
}




 
 
 
 

 
 
