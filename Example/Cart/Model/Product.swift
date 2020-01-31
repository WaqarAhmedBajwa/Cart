//
//  Product.swift
//  ShoppingCart
//
//  Created by Waqar on 2020-01-27.
//  Copyright © 2020 Waqar. All rights reserved.
//

import Foundation
import Cart

class Product: Codable, Equatable, Saleable {
    
    public var quantity: Int? = 0
    private var name: String
    private var price: Float
    private var unit: String
    private var id: String
    
    
    public func getId() -> String {
        return id
    }
    
    public func getName() -> String {
        return name
    }
    
    public func getQuantity() -> Int {
        return quantity ?? 0 
    }
    
    public func getTotal() -> Float {
        return Float(quantity ?? 0 ) * price
    }
    
    public func getPrice() -> Float {
        return price
    }
    
    init(id : String, name : String, price: Float, unit : String = "Bottle") {
        self.id = id
        self.name = name
        self.price = price
        self.unit = unit
        
    }

}

extension Product {
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price && lhs.unit == rhs.unit
    }
    
    func displayPrice() -> String {
        return String.init(format: "$ %.02f per %@", price, unit)
    }
}
