import Foundation

protocol RestaurantsPresentationLogic {
    func presentRestaurants(_ restaurants: [Restaurant])
    func presentRequestFailure(with error: Error)
}

class RestaurantPresenter: RestaurantsPresentationLogic {
    weak var viewController: RestaurantViewController?
    
    // Normally, with more complex UI, here would be visual manipulations/viewModel forming
    func presentRestaurants(_ restaurants: [Restaurant]) {
        viewController?.presentRestaurants(restaurants)
    }
    
    func presentRequestFailure(with error: Error) {
        let message = "It appears that something went wrong while gathering restaurants around you.\nWant to retry?"
        viewController?.presentRequestFailure(with: message)
    }
}
