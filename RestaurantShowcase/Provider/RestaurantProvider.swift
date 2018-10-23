import Foundation
import SDWebImage
import Kingfisher
import Nuke

typealias ImageLoadingCompletion = (UIImage?) -> Void

protocol ImageProviderProtocol {
    func loadImage(url: URL, completion: @escaping ImageLoadingCompletion)
    func preloadImage(url: URL)
    func purge()
}

struct SDWeb: ImageProviderProtocol {
    func loadImage(url: URL, completion: @escaping ImageLoadingCompletion) {
        if let image = SDImageCache.shared().imageFromMemoryCache(forKey: url.absoluteString) {
            completion(image)
        }
        else {
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: .continueInBackground, progress: nil, completed: { (image, _, _, finished) in
                guard finished == true else { return }
                SDImageCache.shared().store(image, forKey: url.absoluteString, completion: {
                    completion(image)
                })
            })
        }
    }
    
    func preloadImage(url: URL) {
        SDWebImageManager.shared().loadImage(with: url, options: .cacheMemoryOnly, progress: nil) { (image, _, _, _, _, _) in }
    }
    
    func purge() {
        SDWebImageManager.shared().imageCache?.clearMemory()
        SDWebImageManager.shared().imageCache?.clearDisk(onCompletion: nil)
    }
}

struct KingFisher: ImageProviderProtocol {
    func loadImage(url: URL, completion: @escaping ImageLoadingCompletion) {
        if let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: url.absoluteString) {
            completion(image)
        } else {
            KingfisherManager.shared.downloader.downloadImage(with: url, options: [], progressBlock: nil) {
                (image, _, _, _) in
                if let image = image {
                    KingfisherManager.shared.cache.store(image, forKey: url.absoluteString)
                }
                completion(image)
            }
        }
    }
    
    func preloadImage(url: URL) {
//        DispatchQueue.global(qos: .utility).async {
            guard KingfisherManager.shared.cache.imageCachedType(forKey: url.absoluteString) == .none else { return }
            KingfisherManager.shared.downloader.downloadImage(with: url, options: [], progressBlock: nil) {
                (image, _, _, _) in
                if let image = image {
                    KingfisherManager.shared.cache.store(image, forKey: url.absoluteString)
                }
            }
//        }
    }
    
    func purge() {
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
    }
}

struct Nukie: ImageProviderProtocol {
    func loadImage(url: URL, completion: @escaping ImageLoadingCompletion) {
        let imageRequest = ImageRequest(url: url)
        if let image = Nuke.ImageCache.shared[imageRequest] {
            completion(image)
        } else {
            ImagePipeline.shared.loadImage(with: imageRequest, progress: nil) { response, error in
                if let response = response {
                    Nuke.ImageCache.shared[imageRequest] = response.image
                    completion(response.image)
                }
            }
        }
    }
    
    func preloadImage(url: URL) {
//        DispatchQueue.global(qos: .utility).async {
            let imageRequest = ImageRequest(url: url)
            ImagePipeline.shared.loadImage(with: imageRequest, progress: nil) { response, error in
                if let response = response {
                    Nuke.ImageCache.shared.storeResponse(response, for: imageRequest)
                }
            }
//        }
    }
    
    func purge() {
        Nuke.ImageCache.shared.removeAll()
    }
}

