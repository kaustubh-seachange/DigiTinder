//
//  DTBtnMacro.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Generic Classes which can be extended.
enum DTBtnMacro {
    case buttonWithImage(image: UIImage,
        cornerRadius: CGFloat,
        target: Any,
        selector: (Selector),
        sizeToFit: Bool)
    
    var new: UIButton {
        switch self {
        case .buttonWithImage(let image,
                              let cornerRadius,
                              let target,
                              let selector,
                              let sizeToFit):
            return createButtonWithImage(image: image,
                                         cornerRadius: cornerRadius,
                                         target: target,
                                         selector: selector,
                                         sizeToFit: sizeToFit)
         }
    }
    
    private func createButtonWithImage(image: UIImage,
                                       cornerRadius: CGFloat,
                                       target: Any,
                                       selector: (Selector),
                                       sizeToFit: Bool) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.addTarget(target, action: selector, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        if sizeToFit {
            button.sizeToFit()
        }
        return button
    }
    
}



