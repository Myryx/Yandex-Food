import Foundation

enum ServiceError: Error {
    case requestError
    case translationError
    
    var localizedDescription: String {
        switch self {
        case .requestError, .translationError:
            return "Something went wrong.\nRetry?"
        }
    }
}

class RestaurantService {
    let translator: RestaurantTranslator
    
    init(translator: RestaurantTranslator = RestaurantTranslator()) {
        self.translator = translator
    }
    
    // I didn't devote much time to the network part, so just a simple request without any wrappers
    func getRestraunts(latitude: Double, longitude: Double, completion: @escaping (Result<[Restaurant], ServiceError>) -> Void) {
        let url = URL(string: "https://eda.yandex/api/v2/catalog?latitude=\(latitude)&longitude=\(longitude)")!

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let payload = json?["payload"] as? [String : Any],
                let places = payload["foundPlaces"] as? [Any]
            else {
                completion(.failure(.requestError))
                return
            }
            
            do {
                let restaurants = try self.translator.translateFrom(array: places)
                completion(.success(restaurants))
            } catch {
                completion(.failure(.translationError))
            }
            return
            
        }
        task.resume()
    }
}
