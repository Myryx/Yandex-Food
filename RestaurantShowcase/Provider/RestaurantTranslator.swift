import Foundation

public enum TranslatorError: Error {
    case invalidObjectsInArray
    case invalidJSONObject
}

class RestaurantTranslator {
    /// перечисление ключей json объекта в ответе сервера
    enum Keys: String {
        case id
        case name
        case footerDescription
        case picture
        case place
        case uri
    }
    
    func translateFrom(array: [Any]) throws -> [Restaurant] {
        return try array.map {
            guard let object = $0 as? [String: Any] else {
                throw TranslatorError.invalidObjectsInArray
            }
            return try translateFrom(dictionary: object)
        }
    }
    
    func translateFrom(dictionary json: [String: Any]) throws -> Restaurant {
        guard
            let place = json[Keys.place.rawValue] as? [String: Any],
            let id = place[Keys.id.rawValue] as? Int,
            let name = place[Keys.name.rawValue] as? String,
            let footerDescription = place[Keys.footerDescription.rawValue] as? String,
            let picture = place[Keys.picture.rawValue] as? [String: Any],
            let picturePath = picture[Keys.uri.rawValue] as? String
        else {
            throw TranslatorError.invalidJSONObject
        }
        
        return Restaurant(
            id: id,
            title: name,
            description: footerDescription,
            picturePath: picturePath
        )
    }
}
