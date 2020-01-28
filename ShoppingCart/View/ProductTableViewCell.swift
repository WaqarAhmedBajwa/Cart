//
//  ProductTableViewCell.swift
//  ShoppingCart
//
//  Created by Waqar on 2020-01-27.
//  Copyright © 2020 Waqar. All rights reserved.
//

import UIKit

protocol CartDelegate {
    func updateCart(cell: ProductTableViewCell)
}

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var delegate: CartItemDelegate?
    var quantity: Int = 0 {
        
        didSet {
            decrementButton.isEnabled = quantity > 0
            decrementButton.backgroundColor = !decrementButton.isEnabled ? .gray : .black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        incrementButton.layer.cornerRadius = 10
        incrementButton.clipsToBounds = true
        
        decrementButton.layer.cornerRadius = 10
        decrementButton.clipsToBounds = true
        
//        decrementButton.isEnabled = quantity > 0
//        decrementButton.backgroundColor = !decrementButton.isEnabled ? .gray : .black
    }
    
    
    @IBAction func updateCartItemQuantity(_ sender: Any) {
         if (sender as! UIButton).tag == 0 {
             quantity = quantity + 1
         } else if quantity > 0 {
             quantity = quantity - 1
         }
         
         decrementButton.isEnabled = quantity > 0
         decrementButton.backgroundColor = !decrementButton.isEnabled ? .gray : .black
         
         self.quantityLabel.text = String(describing: quantity)
         self.delegate?.updateCartItem(cell: self, quantity: quantity)
     }
}
