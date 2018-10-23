import Foundation
import SDWebImage
import Kingfisher
import Nuke

public typealias ImageLoadingCompletion = (UIImage?) -> Void

public protocol ImageProcessorProtocol {
    func loadImage(url: URL, completion: @escaping ImageLoadingCompletion)
    func preloadImage(url: URL)
    func purge()
}

public struct SDWeb: ImageProcessorProtocol {
    public func loadImage(url: URL, completion: @escaping ImageLoadingCompletion) {
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
    
    public func preloadImage(url: URL) {
        SDWebImageManager.shared().loadImage(with: url, options: .cacheMemoryOnly, progress: nil) { (image, _, _, _, _, _) in
        }
    }
    
    public func purge() {
        SDWebImageManager.shared().imageCache?.clearMemory()
        SDWebImageManager.shared().imageCache?.clearDisk(onCompletion: nil)
    }
}

public struct KingFisher: ImageProcessorProtocol {
    public func loadImage(url: URL, completion: @escaping ImageLoadingCompletion) {
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
    
    public func preloadImage(url: URL) {
        guard KingfisherManager.shared.cache.imageCachedType(forKey: url.absoluteString) == .none else { return }
        KingfisherManager.shared.downloader.downloadImage(with: url, options: [], progressBlock: nil) {
            (image, _, _, _) in
            if let image = image {
                KingfisherManager.shared.cache.store(image, forKey: url.absoluteString)
            }
        }
    }
    
    public func purge() {
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
    }
}

public struct Nukee: ImageProcessorProtocol {
    public func loadImage(url: URL, completion: @escaping ImageLoadingCompletion) {
        let imageRequest = ImageRequest(url: url)
        ImagePipeline.shared.loadImage(with: imageRequest, progress: nil) { response, error in
            if let response = response {
                Nuke.ImageCache.shared.storeResponse(response, for: imageRequest)
                completion(response.image)
            }
        }
    }
    
    public func preloadImage(url: URL) {
        let imageRequest = ImageRequest(url: url)
        ImagePipeline.shared.loadImage(with: imageRequest, progress: nil) { response, error in
            if let response = response {
                Nuke.ImageCache.shared.storeResponse(response, for: imageRequest)
            }
        }
    }
    
    public func purge() {
        Nuke.ImageCache.shared.removeAll()
    }
}

