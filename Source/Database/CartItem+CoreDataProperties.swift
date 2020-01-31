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
    
    public var quantity: Int? {
        get {
            Int(totalItem)
        }
        set {
            totalItem = Int16(newValue ?? 0)
        }
    }
    
    
    public func getId() -> String {
        return id
    }
    
    public func getName() -> String {
        return name
    }
    
    public func getQuantity() -> Int {
        return Int(totalItem)
    }
    
    public func getTotal() -> Float {
       return subTotal
    }
    
    public func getPrice() -> Float {
        return price
    }
    
    
    convenience init(with item: Saleable) {
        self.init(context: PersistanceService.shared.backgroundContext)
        self.id = item.getId()
        self.quantity = item.getQuantity()
        self.name = item.getName()
        self.price = item.getPrice()
       
    }
    
}
