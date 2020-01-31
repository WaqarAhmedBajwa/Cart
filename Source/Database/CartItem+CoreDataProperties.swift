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
    
    
    convenience init(product: Saleable) {
//        self.init(context: PersistanceService.shared.context)
        self.init(usedContext: PersistanceService.shared.context)
        self.id = product.getId()
        self.quantity = product.getQuantity()
        self.name = product.getName()
        self.price = product.getPrice()
       
    }
    
}


public extension CartItem {

    convenience init(usedContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
        self.init(entity: entity, insertInto: usedContext)
    }

}

 
 
 
 

 
 
