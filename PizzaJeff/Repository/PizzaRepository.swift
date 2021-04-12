//
//  PizzaRepository.swift
//  PizzaJeff
//
//  Created by Alex Morral on 12/4/21.
//

import Foundation

class PizzaRepository {
    var dataSource: PizzaDataSource!
    
    init(dataSource: PizzaDataSource) {
        self.dataSource = dataSource
    }
    
    func getPizzas(onSuccess: @escaping ( (Pizzas) -> Void ), onError: @escaping ( (ApiError) -> Void )) {
        dataSource.getPizzaList(onSuccess: onSuccess, onError: onError)
    }
}
