//
//  DigiTinderInteractor.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit

let screenMargin = (UIScreen.main.bounds.size.width/2) * 0.75

//MARK: 1 protocol
protocol DigiTinderInteractor { }

//MARK: 2 Protocol extension constrained to UIPanGestureRecognizer
extension DigiTinderInteractor where Self: UIPanGestureRecognizer {
    //MARK 3 Main function
    func swipeView(_ view: UIView) {
        switch state {
        case .changed:
            let translation = self.translation(in: view.superview)
            view.transform = transform(view: view, for: translation)
        case .ended:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: [], animations: {
                //view.transform = .identity
                view.removeFromSuperview()
            }, completion: nil)
            
        default:
            break
        }
    }
    
    //MARK: 4 Helper method that handles transformation
    private func transform(view: UIView, for translation: CGPoint) -> CGAffineTransform {
        let moveBy = CGAffineTransform(translationX: translation.x, y: translation.y)
        let rotation = -sin(translation.x / (view.frame.width * 4.0))
        return moveBy.rotated(by: rotation)
    }    
}

extension UIPanGestureRecognizer: DigiTinderInteractor {}
