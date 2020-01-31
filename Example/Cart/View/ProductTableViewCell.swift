//
//  ProductTableViewCell.swift
//  ShoppingCart
//
//  Created by Waqar on 2018-06-04.
//  Copyright © 2020 Waqar All rights reserve
//

import UIKit
import Cart


class ProductTableViewCell: UITableViewCell ,CartItemDelegate{

    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var counterView: CounterView!
    
    var updateCart : ((Int) -> Void)?
    
    override func awakeFromNib() {
        counterView.delegate  = self
    }

    func updateCartItem(quantity: Int) {
        if let callback = updateCart {
            callback(quantity)
        }
    }
}
