import Foundation

class RestaurantInteractor {
    let service: RestaurantService
    let presenter: RestaurantsPresentationLogic
    
    init(service: RestaurantService = RestaurantService(),
         presenter: RestaurantsPresentationLogic = RestaurantPresenter()) {
        self.service = service
        self.presenter = presenter
    }
    
    func fetchRestaurants(latitude: Double = 55.762885, longitude: Double = 37.597360) {
        service.getRestraunts(latitude: latitude, longitude: longitude) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(restaurants):
                    self?.presenter.presentRestaurants(restaurants)
                case let .failure(error):
                    self?.presenter.presentRequestFailure(with: error)
                }
            }
        }
    }
}
