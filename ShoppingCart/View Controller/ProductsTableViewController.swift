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
        cart.notifyDataSet()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        products = ProductsListHelper().all()
        //Workaround to avoid the fadout the right bar button item
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        products = cart.mapWithCart(saleable: products)
        NotificationCenter.default.addObserver(forName: Notification.Name.init(rawValue: CartManager.UPDATE_TRIGGER),
                                               object: nil,
                                               queue: OperationQueue.main) { (notification) in
            if let data = notification.object as?  CartTotal{
            print(data)
                self.navigationItem.rightBarButtonItem?.title = "Checkout (\(data.quantity))"
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
        cell.nameLabel.text = product.name
        cell.priceLabel.text = product.displayPrice()
        cell.counterView.quantity = product.getQuantity()
        cell.counterView.delegate = self
       
        return cell
    }
}


extension ProductsTableViewController: CartItemDelegate {
    
    func updateCartItem(cell: UITableViewCell, quantity: Int) {
        guard let cell = cell as? ProductTableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let product = products[indexPath.row]
        product.quantity = quantity
        cart.updateItem(product: product)
    }
    
}
