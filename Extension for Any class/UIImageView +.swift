fileprivate let imageCache = NSCache<NSString, UIImage>()

public extension UIImageView {
    /// load image from internet and save in cache
    /// - Parameter URLString: url
    /// - Parameter placeholder: if url error show placeholder
    func loadImageUsingCacheWithURLString(_ URLString: String, placeholder: UIImage? = UIImage(systemName: "person.fill.questionmark")) {
        
        image = nil
        
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession
                .shared
                .dataTask(with: url, completionHandler: { (data, _, error) in
                
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL")
                    image = placeholder
                    return
                }
                
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        DispatchQueue.main.async { [weak self] in
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self?.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
