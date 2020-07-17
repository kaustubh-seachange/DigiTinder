//
//  DTResourceCaching.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit

let resourceCache = NSCache<NSString, UIImage>()
let commonUI = CommonUI()

extension UIImageView {
    // MARK: - Check for genericType.
    func resourceCached(from stringUrl: String, placeHolder: UIImage?) {
        self.image = nil
        if let resourceCached = resourceCache.object(forKey: NSString(string: stringUrl)) {
            self.image = resourceCached
            return
        }
        
        commonUI.createActivityIndicator(using: self,
                                         aFrame: CGRect(x: self.frame.size.width/2,
                                                        y: self.frame.size.height/2,
                                                        width: 24.0,
                                                        height: 24.0))
        if let url = URL(string: stringUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        commonUI.stopActivityIndicator()
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    commonUI.stopActivityIndicator()
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            resourceCache.setObject(downloadedImage, forKey: NSString(string: stringUrl))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
