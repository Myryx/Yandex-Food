//
//  Interactor.swift
//  RestaurantShowcase
//
//  Created by Yanislav Kononov on 10/21/18.
//  Copyright © 2018 Yanislav. All rights reserved.
//

import Foundation

class RestaurantInteractor {
    let service: RestaurantService
    let presenter: RestaurantsPresentationLogic
    
    init(service: RestaurantService = RestaurantService(),
         presenter: RestaurantsPresentationLogic = RestaurantPresenter()) {
        self.service = service
        self.presenter = presenter
    }
    
    func fetchRestaurants() {
        service.getRestraunts(latitude: 55.762885, longitude: 37.597360) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(restaurants):
                    self?.presenter.presentRestaurants(restaurants)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
