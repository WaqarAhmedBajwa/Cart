//
//  CartItemTableViewCell.swift
//  ShoppingCart
//
//  Created by Waqar on 2010-01-27.
//  Copyright © 2020 Waqar All rights reserve
//

import UIKit

class CartItemTableViewCell: UITableViewCell ,CartItemDelegate {
    
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

