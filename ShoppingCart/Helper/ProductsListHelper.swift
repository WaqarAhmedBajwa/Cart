//
//  ProductsManager.swift
//  ShoppingCart
//
//  Created by Waqar on 2018-06-04.
//  Copyright © 2020 Waqar All rights reserve
//

import Foundation

class ProductsListHelper {
    
    private let productsJson = """
        [
            {
                "id": "1",
                "name": "Peas",
                "price": 1.0,
                "unit": "bag"
            },
            {
                "id": "2",
                "name": "Eggs",
                "price": 2.0,
                "unit": "dozen"
            },
            {
                "id": "3",
                "name": "Milk",
                "price": 4.0,
                "unit": "bottle"
            },
            {
                "id": "4",
                "name": "Beans",
                "price": 3.0,
                "unit": "can"
            }
        ]
        """.data(using: .utf8)!
    
    func all() -> [Product] {
        let decoder = JSONDecoder()
        let products = try! decoder.decode([Product].self, from: productsJson)
        
        return products
    }
}

