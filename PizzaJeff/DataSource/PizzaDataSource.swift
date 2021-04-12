//
//  PizzaDataSource.swift
//  PizzaJeff
//
//  Created by Alex Morral on 12/4/21.
//

import Foundation

protocol PizzaDataSource {
    func getPizzaList(onSuccess: @escaping ( (Pizzas) -> Void ), onError: @escaping ( (ApiError) -> Void ))
}
