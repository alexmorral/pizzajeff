//
//  ConfirmationViewController.swift
//  PizzaJeff
//
//  Created by Alex Morral on 12/2/21.
//

import UIKit

class ConfirmationViewController: UIViewController, StoryboardInstantiable {
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Summary"
        configureNavigationBar()
        configureOrdersTableView()
        confirmButton.isEnabled = orders.count > 0
    }

    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
    }
    
    @objc func closeTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func configureOrdersTableView() {
        ordersTableView.dataSource = self
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        
    }
}

extension ConfirmationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier) as? OrderTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(order: orders[indexPath.row])
        return cell
    }
    
    
}
