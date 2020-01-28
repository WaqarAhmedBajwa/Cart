//
//  ProductsTableViewController.swift
//  ShoppingCart
//
//  Created by Waqar on 2020-01-27.
//  Copyright © 2020 Waqar. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController {
    
    fileprivate var products:[Product] = ProductsListHelper().all()
    fileprivate var cart = CartManager.shared
    
    fileprivate let reuseIdentifier = "ProductCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.rightBarButtonItem?.title = "Checkout (\(cart.totalQuantity))"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        products = ProductsListHelper().all()
        //Workaround to avoid the fadout the right bar button item
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        //Update cart if some items quantity is equal to 0 and reload the product table and right button bar item
        
        products = cart.mapWithCart(saleable: products)
        NotificationCenter.default.addObserver(forName: Notification.Name.init(rawValue: CartManager.UPDATE_TRIGGER),
                                               object: nil,
                                               queue: OperationQueue.main) { (notification) in
            if let data = notification.object as?  CartTotal{
            print(data)
                self.navigationItem.rightBarButtonItem?.title = "Checkout (\(data.quantity))"
            }
        }
//        print(cart.total)
        tableView.reloadData()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
