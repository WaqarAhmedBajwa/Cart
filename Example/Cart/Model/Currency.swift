//
//  Currency.swift
//  ShoppingCart
//
//  Created by D. on 2018-06-08.
//  Copyright © 2020 Waqar. All rights reserved.
//

import Foundation

struct Currency: Codable {
    
    var quotes : Dictionary<String,Float>
    var timestamp : Int64
}
