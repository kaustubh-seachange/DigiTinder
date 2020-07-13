//
//  DTImageMacro.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Generic Classes which can be extended.
enum DTImageMacro {
    case standardImageView(image: UIImage,
        cornerRadius: CGFloat,
        interactionEnabled: Bool,
        contentMode: UIView.ContentMode,
        sizeToFit: Bool)
    
    var new: UIImageView {
        switch self {
        case .standardImageView(let image,
                                let cornerRadius,
                                let interactionEnabled,
                                let contentMode,
                                let sizeToFit):
            return createStandardImageView(image: image,
                                           cornerRadius: cornerRadius,
                                           interactionEnabled: interactionEnabled,
                                           
                                           contentMode: contentMode,
                                           sizeToFit: sizeToFit)
        }
    }
    
    private func createStandardImageView(image: UIImage,
                                         cornerRadius: CGFloat,
                                         interactionEnabled: Bool,
                                         contentMode: UIView.ContentMode,
                                         sizeToFit: Bool) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = interactionEnabled
        imageView.contentMode = contentMode
        if sizeToFit {
            imageView.sizeToFit()
        }
        return imageView
    }
}
