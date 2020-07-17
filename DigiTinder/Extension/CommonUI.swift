//
//  CommonUI.swift
//  DigiTinder
//
//  Created by Kaustubh on 17/07/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import UIKit

// MARK: Common Class to handle the UI Elements.
class CommonUI : UIView {
    // MARK: Properties.
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Method(s).
    func createActivityIndicator(using aView: UIView, aFrame: CGRect) {
        activityIndicator = UIActivityIndicatorView.init(frame: aFrame)
        activityIndicator.style = .large
        activityIndicator.color = .black
        activityIndicator.backgroundColor = UIColor.clear
        activityIndicator.startAnimating()
        aView.addSubview(activityIndicator)
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
}
