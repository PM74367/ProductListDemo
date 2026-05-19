//
//  RemoteImageView.swift
//  ProductListDemo
//
//  Created by Puneet on 08/05/26.
//

import UIKit

final class RemoteImageCache {
    static var shared = RemoteImageCache()
    private var cache = NSCache<NSString, UIImage>()
    private init() {}
    
    func getImage(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

final class RemoteImageView: UIImageView {
    func downloadImage(from url: URL) {
        if let cachedImage = RemoteImageCache.shared.getImage(for: url.absoluteString) {
            self.image = cachedImage
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            guard let image = UIImage(data: data) else { return }
            RemoteImageCache.shared.setImage(image, for: url.absoluteString)
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
