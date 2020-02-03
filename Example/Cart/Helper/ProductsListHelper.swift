//
//  ProductsManager.swift
//  ShoppingCart
//
//  Created by Waqar on 2020-01-27.
//  Copyright © 2020 Waqar. All rights reserved.
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
        var products = [Product]()
//        let decoder = JSONDecoder()
//        products = try! decoder.decode([Product].self, from: productsJson)
        
        for index in 1...50{
            let product = Product(id: String(index), name: "Product \(index)", price: 2.0, unit: "bag")
            products.append(product)
        }
        return products
    }
}

