//
//  Product.swift
//  ShoppingCart
//
//  Created by Waqar on 2020-01-27.
//  Copyright © 2020 Waqar. All rights reserved.
//

import Foundation

class Product: Codable, Equatable, Saleable {
    
    var quantity: Int? = 0
    var name: String
    var price: Float
    var unit: String
    var id: String
    
    
    func getId() -> String {
        return id
    }
    
    func getName() -> String {
        return name
    }
    
    func getQuantity() -> Int {
        return quantity ?? 0 
    }
    
    func getTotal() -> Float {
        return Float(quantity ?? 0 ) * price
    }
    
    func getPrice() -> Float {
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
