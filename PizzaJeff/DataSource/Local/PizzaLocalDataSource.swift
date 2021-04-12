//
//  PizzaLocalDataSource.swift
//  PizzaJeff
//
//  Created by Alex Morral on 12/4/21.
//

import Foundation

class PizzaLocalDataSource: PizzaDataSource {
    func getPizzaList(onSuccess: @escaping ( (Pizzas) -> Void ), onError: @escaping ( (ApiError) -> Void )) {
        if let path = Bundle.main.path(forResource: "PizzaList", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let pizzaList = try JSONDecoder().decode(Pizzas.self, from: data)
                onSuccess(pizzaList)
                return
            } catch {
                onError(ApiError.serializationError)
                return
            }
        }
        onError(ApiError.networkingError)
    }
}
