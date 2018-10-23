import Foundation
import UIKit

public class RestaurantTableDirector: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var restaurants: [Restaurant] = []
    private(set) var imageProvider: ImageProviderProtocol = Nukie()
    
    public override init() {
        imageProvider.purge()
    }
    
    func setRestaurants(_ restaurants: [Restaurant]) {
        self.restaurants = restaurants
    }
    
    func setImageProvider(_ imageProvider: ImageProviderProtocol) {
        self.imageProvider.purge()
        self.imageProvider = imageProvider
    }
    
    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    public func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let model = restaurants[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(RestaurantCell.self)") as? RestaurantCell
        else { return UITableViewCell() }
        cell.configure(with: model)
        if let url = URL(string: model.fullPicturePath()) {
            imageProvider.loadImage(url: url) { image in
//                guard tableView.visibleCells.contains(cell) else { return }
                cell.thumbnailImageView.image = image
            }
        }
        return cell
    }
}

extension RestaurantTableDirector: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let model = restaurants[indexPath.row]
            if let url = URL(string: model.fullPicturePath()) {
                self.imageProvider.preloadImage(url: url)
            }
        }
    }
}


// local extensions. Normally located in a separate file
fileprivate extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

