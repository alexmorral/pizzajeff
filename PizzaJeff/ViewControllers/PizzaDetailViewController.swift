//
//  PizzaDetailViewController.swift
//  PizzaJeff
//
//  Created by Alex Morral on 12/2/21.
//

import UIKit
import SDWebImage

class PizzaDetailViewController: UIViewController, StoryboardInstantiable {

    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var pizzaImgView: UIImageView!
    @IBOutlet weak var pizzaNameLabel: UILabel!
    @IBOutlet weak var pizzaDescription: UILabel!
    @IBOutlet weak var pizzaSizeSegControl: UISegmentedControl!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountStepper: UIStepper!
    @IBOutlet weak var priceLabel: UILabel!
    
    var currentAmount: Int = 1
    var pizza: Pizza!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
    }
    
    func initializeViews() {
        pizzaImgView.sd_setImage(with: URL(string: pizza.imageURL), completed: nil)
        pizzaNameLabel.text = pizza.name
        pizzaDescription.text = pizza.content
        
        configureSegmentedControl()
        configureAmountStepper()
        updateOrderPrice()
    }
    
    func configureSegmentedControl() {
        pizzaSizeSegControl.removeAllSegments()
        for size in pizza.prices {
            pizzaSizeSegControl.insertSegment(withTitle: size.size.rawValue, at: pizzaSizeSegControl.numberOfSegments, animated: false)
        }
        if let bestPrice = CSatManager.shared.bestPriceForCurrentUser(pizza: pizza) {
            for i in 0..<pizzaSizeSegControl.numberOfSegments {
                if pizzaSizeSegControl.titleForSegment(at: i) == bestPrice.size.rawValue {
                    pizzaSizeSegControl.selectedSegmentIndex = i
                }
            }
        }
    }
    
    func configureAmountStepper() {
        amountStepper.stepValue = 1
        amountStepper.value = Double(currentAmount)
        amountStepper.maximumValue = 10
        amountStepper.minimumValue = 1
        updateAmountText()
    }
    
    @IBAction func sizeChanged(_ sender: Any) {
        updateOrderPrice()
    }
    
    @IBAction func amountChanged(_ sender: Any) {
        currentAmount = Int(amountStepper.value)
        updateAmountText()
        updateOrderPrice()
    }
    
    func updateAmountText() {
        amountLabel.text = "\(currentAmount)"
    }
    
    func updateOrderPrice() {
        let totalPrice = currentPriceSelected().price * Double(currentAmount)
        priceLabel.text = totalPrice.formatToEur()
    }
    
    func currentPriceSelected() -> Price {
       return pizza.prices.first(where: { $0.size.rawValue == pizzaSizeSegControl.titleForSegment(at: pizzaSizeSegControl.selectedSegmentIndex) })!
    }
    
    func createOrder() -> Order {
        return pizza.order(price: currentPriceSelected(), quantity: currentAmount)
    }
    
    @IBAction func instantOrderTapped(_ sender: Any) {
        let order = createOrder()
        coordinator?.addOrderToCart(order: order)
        coordinator?.showConfirmation()
    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
        let order = createOrder()
        coordinator?.addOrderToCart(order: order)
        Alerts.displayMessage(message: "Order added to your cart")
    }
}
