//
//  DTLabelMacro.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Generic Classes which can be extended.
enum DTLabelMacro {
    case standardLabel(text: String,
        textColor: UIColor,
        fontStyle: UIFont.TextStyle,
        textAlignment: NSTextAlignment?,
        sizeToFit: Bool,
        adjustToFit: Bool)
    
    var new: UILabel {
        switch self {
        case .standardLabel(let text,
                            let textColor,
                            let fontStyle,
                            let textAlignment,
                            let sizeToFit,
                            let adjustToFit):
            return createStandardLabel(text: text,
                                       textColor: textColor,
                                       fontStyle: fontStyle,
                                       textAlignment: textAlignment,
                                       sizeToFit: sizeToFit,
                                       adjustToFit: adjustToFit)
        }
    }
    
    private func createStandardLabel(text: String,
                                     textColor: UIColor,
                                     fontStyle: UIFont.TextStyle,
                                     textAlignment: NSTextAlignment?,
                                     sizeToFit: Bool,
                                     adjustToFit: Bool) -> UILabel {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = adjustToFit
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: fontStyle)
        label.textAlignment = textAlignment ?? .left
        label.textColor = textColor
        if sizeToFit {
            label.sizeToFit()
        }
        return label
    }
}
