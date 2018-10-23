import Foundation
import UIKit

struct Restaurant: RestaurantCellConfigurable {
    let id: Int
    let title: String
    let description: String?
    let picturePath: String?
}

extension Restaurant {
    func fullPicturePath(for width: Int = 100, and height: Int = 75, basePath: String = RestaurantService.basePath) -> String {
        return "\(basePath)\(picturePath!)"
            .replacingOccurrences(of: "{w}", with: String(width))
            .replacingOccurrences(of: "{h}", with: String(height))
    }
}
