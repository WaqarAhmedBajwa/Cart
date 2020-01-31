//
//  ProductsTableViewController.swift
//  ShoppingCart
//
//  Created by Waqar on 2020-01-27.
//  Copyright © 2020 Waqar. All rights reserved.
//

import UIKit
import Cart

class ProductsTableViewController: UITableViewController {
    
    fileprivate var products:[Product] = ProductsListHelper().all()
    fileprivate var cart = CartManager.shared
    
    fileprivate let reuseIdentifier = "ProductCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cart.notifyDataSet()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        products = ProductsListHelper().all()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        products = cart.mapWithCart(saleable: products)
        NotificationCenter.default.addObserver(forName: Notification.Name.init(rawValue: CartManager.UPDATE_TRIGGER),
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] (notification) in
            if let data = notification.object as?  CartTotal{
            print(data)
                self?.navigationItem.rightBarButtonItem?.title = "Checkout (\(data.totalItems))"
                
            }
        }

        tableView.reloadData()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProductTableViewCell
        
        let product = products[indexPath.item]
        cell.nameLabel.text = product.getName()
        cell.priceLabel.text = product.displayPrice()
        cell.counterView.quantity = product.getQuantity()
        
        cell.updateCart = { [weak self] quantity in
            
            product.quantity = quantity
            self!.cart.updateItem(saleable: product)
          
        }
       
        return cell
    }
}



