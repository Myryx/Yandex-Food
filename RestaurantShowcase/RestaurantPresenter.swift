//
//  RestaurantPresenter.swift
//  RestaurantShowcase
//
//  Created by Yanislav Kononov on 10/22/18.
//  Copyright © 2018 Yanislav. All rights reserved.
//

import Foundation

protocol RestaurantsPresentationLogic {
    func presentRestaurants(_ restaurants: [Restaurant])
}

class RestaurantPresenter: RestaurantsPresentationLogic {
    weak var viewController: RestaurantViewController?
    
    // Normally, with more complex UI, here would be visual manipulations/ viewModel forming
    func presentRestaurants(_ restaurants: [Restaurant]) {
        viewController?.presentRestaurants(restaurants)
    }
}
