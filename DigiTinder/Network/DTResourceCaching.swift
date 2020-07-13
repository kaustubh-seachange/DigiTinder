//
//  DTResourceCaching.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit

let resourceCaching = NSCache<NSString, UIImage>()

extension UIImageView {
    // MARK: - Check for genericType.
    func resourceCachingFrom(_ urlString: String, placeHolder: UIImage?) {
        self.image = nil
        if let resourceCached = resourceCaching.object(forKey: NSString(string: urlString)) {
            self.image = resourceCached
            return
        }
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            resourceCaching.setObject(downloadedImage, forKey: NSString(string: urlString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
