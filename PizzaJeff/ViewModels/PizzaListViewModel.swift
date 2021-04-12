//
//  PizzaListViewModel.swift
//  PizzaJeff
//
//  Created by Alex Morral on 12/4/21.
//

import Foundation

class PizzaListViewModel {
    
    var pizzaRepo: PizzaRepository!
    var pizzas: Pizzas?
    
    init() {
        pizzaRepo = PizzaRepository(dataSource: PizzaLocalDataSource())
        loadPizzas()
    }
    
    private func loadPizzas() {
        pizzaRepo.getPizzas { (pizzas) in
            self.pizzas = pizzas
        } onError: { (err) in
            print("Error")
        }
    }
}
