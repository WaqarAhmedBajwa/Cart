//
//  Saleable.swift
//  ShoppingCart
//
//  Created by Waqar Ahmed on 24/01/2020.
//  Copyright © 2020 Waqar. All rights reserved.
//

import Foundation


public protocol Saleable {
    
    var quantity : Int?  { get set }
    
    func getId() -> String
    func getName() -> String
    func getQuantity() -> Int
    func getTotal() -> Float
    func getPrice() -> Float
}
