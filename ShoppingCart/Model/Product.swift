//
//  Product.swift
//  ShoppingCart
//
//  Created by Waqar on 2018-06-04.
//  Copyright © 2020 Waqar All rights reserve
//

import Foundation

class Product: Codable, Equatable, Saleable {
    
    var quantity: Int? = 1
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
    

}

extension Product {
    // MARK: Equatable
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price && lhs.unit == rhs.unit
    }
    
    func displayPrice() -> String {
        return String.init(format: "$ %.02f per %@", price, unit)
    }
}
