//
//  ProductsTableViewController.swift
//  ShoppingCart
//
//  Created by Waqar on 2018-06-04.
//  Copyright © 2020 Waqar All rights reserve
//

import UIKit
import Combine


class ProductsTableViewController: UITableViewController {
    
    fileprivate var products:[Product] = ProductsListHelper().all()
    fileprivate var cart = CartManager.shared
    
    fileprivate let reuseIdentifier = "ProductCell"
    
//    @Published
//    var cartValues: CartTotal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        products = ProductsListHelper().all()
        //Workaround to avoid the fadout the right bar button item
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        //Update cart if some items quantity is equal to 0 and reload the product table and right button bar item
     
        products = cart.mapWithCart(saleable: products)
        guard let barItem = self.navigationItem.rightBarButtonItem else { return }
        let totalQuantitySubscriber = Subscribers.Assign(object: barItem, keyPath: \.title)
        cart.publisher.subscribe(totalQuantitySubscriber)
        cart.setup()
        tableView.reloadData()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreateWaqar
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showCart" {
//            if let cartViewController = segue.destination as? CartViewController {
//                cartViewController.cart = self.cart
//            }
//        }
//    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProductTableViewCell
        
        let product = products[indexPath.item]
        
        cell.delegate = self
        cell.nameLabel.text = product.name
        cell.quantityLabel.text = String(product.getQuantity())
        cell.priceLabel.text = product.displayPrice()
        cell.quantity = product.getQuantity()
       
        return cell
    }
}


extension ProductsTableViewController: CartItemDelegate {
    
    // MARK: - CartItemDelegate
    func updateCartItem(cell: UITableViewCell, quantity: Int) {
        guard let cell = cell as? ProductTableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let product = products[indexPath.row]
        
        //Update cart item quantity
        product.quantity = quantity
        //Update Cart with product
        cart.updateItem(product: product)
    }
    
}
