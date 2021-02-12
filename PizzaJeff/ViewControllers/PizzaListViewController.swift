//
//  PizzaListViewController.swift
//  PizzaJeff
//
//  Created by Alex Morral on 12/2/21.
//

import UIKit

class PizzaListViewController: UIViewController, StoryboardInstantiable {
    
    weak var coordinator: MainCoordinator?
    @IBOutlet weak var pizzasCollectionView: UICollectionView!
    
    var pizzaList: Pizzas?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pizza Jeff"
        configureNavigationBar()
        configureCollectionView()
        getPizzasData()
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(logoutTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart.fill"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cartTapped))
    }
    
    @objc func logoutTapped() {
        Alerts.showConfirmationActionSheet(vcToPresent: self,
                                           title: "Confirm",
                                           description: "Are you sure you want to log out?",
                                           cancelText: "Cancel",
                                           actionText: "Log out",
                                           isDestructive: false) { [weak self] in
            self?.coordinator?.logoutUser()
        }
    }
    
    @objc func cartTapped() {
        coordinator?.showConfirmation()
    }
    
    func configureCollectionView() {
        pizzasCollectionView.dataSource = self
        pizzasCollectionView.delegate = self
        self.view.layoutIfNeeded()
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: pizzasCollectionView.frame.width, height: 120)
        flowLayout.sectionInset = sectionInsets
        flowLayout.minimumLineSpacing = sectionInsets.left
        pizzasCollectionView.collectionViewLayout = flowLayout
    }
    
    func getPizzasData() {
        DataManager.getPizzaList { (pizzas) in
            self.pizzaList = pizzas
            DispatchQueue.main.async { [weak self] in
                self?.pizzasCollectionView.reloadData()
            }
        } onError: { (error) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                Alerts.showErrorAlert(vcToPresent: self, error: error)
            }
        }
    }
    
}

extension PizzaListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pizzaList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PizzaListCollectionViewCell.identifier, for: indexPath) as? PizzaListCollectionViewCell else { return UICollectionViewCell() }
        
        guard let pizzaList = pizzaList else { return UICollectionViewCell() }
        let pizza = pizzaList[indexPath.row]
        cell.setup(pizza: pizza)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pizzaList = pizzaList else { return }
        let pizza = pizzaList[indexPath.row]
        coordinator?.showPizzaDetail(pizza: pizza)
    }
}

extension PizzaListViewController: PizzaCollectionCellDelegate {
    func addToCartTapped(order: Order) {
        coordinator?.addOrderToCart(order: order)
        Alerts.displayMessage(message: "Order added to your cart")
    }
}
