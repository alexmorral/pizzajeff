//
//  DataManager.swift
//  PizzaJeff
//
//  Created by Alex Morral on 12/2/21.
//

import Foundation

class DataManager {
    
    //This methods don't need to be static, but as we don't have to save Headers, Tokens, etc. I decided to make it static
    
    static func getPizzaListNetwork(onSuccess: @escaping ( (Pizzas) -> Void ), onError: @escaping ( (ApiError) -> Void )) {
        let url = URL(string: "https://gist.github.com/eliseo-juan/c9c124b0899ae9adc254146783c0b764/raw")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                onError(ApiError.networkingError)
                return
            }
            guard let data = data else {
                onError(ApiError.noDataReceived)
                return
            }
            
            do {
                let pizzaList = try JSONDecoder().decode(Pizzas.self, from: data)
                onSuccess(pizzaList)
                return
            } catch {
                onError(ApiError.serializationError)
                return
            }
        }
        task.resume()
    }
    
    static func getPizzaList(onSuccess: @escaping ( (Pizzas) -> Void ), onError: @escaping ( (ApiError) -> Void )) {
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
