//
//  Currency.swift
//  ShoppingCart
//
//  Created by Waqar on 2018-06-08.
//  Copyright © 2020 Waqar All rights reserve
//

import Foundation

struct Currency: Codable {
    
    var quotes : Dictionary<String,Float>
    var timestamp : Int64
}
