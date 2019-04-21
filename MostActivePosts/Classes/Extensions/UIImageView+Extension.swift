//
//  UIImageView+Extension.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/20/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import UIKit

let cache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func cacheImage(urlString: String){
        let url = URL(string: urlString)
        
        image = nil
        
        if let cachedImage = cache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
            if let response = data {
                DispatchQueue.main.async {
                    if let loadedImage = UIImage(data: response) {
                        cache.setObject(loadedImage, forKey: urlString as AnyObject)
                        self.image = loadedImage
                    }
                }
            }
        }.resume()
    }
}
