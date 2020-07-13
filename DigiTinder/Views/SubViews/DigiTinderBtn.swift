//
//  DigiTinderBtn.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit

class DigiTinderBtn: DigiTinderFoundryView {
    lazy var likeButton: UIButton = {
        let b = DTBtnMacro.buttonWithImage(image: #imageLiteral(resourceName: "like"), cornerRadius: 0, target: self, selector: #selector(like), sizeToFit: true).new
        return b
    }()
    
    lazy var passButton: UIButton = {
        let b = DTBtnMacro.buttonWithImage(image: #imageLiteral(resourceName: "pass"), cornerRadius: 0, target: self, selector: #selector(pass), sizeToFit: true).new
        return b
    }()
    
    lazy var superLikeButton: UIButton = {
        let b = DTBtnMacro.buttonWithImage(image: #imageLiteral(resourceName: "superlike"), cornerRadius: 0, target: self, selector: #selector(superLike), sizeToFit: true).new
        return b
    }()
    
    lazy var container: UIStackView = {
        let c = UIStackView(arrangedSubviews: [
            self.likeButton, self.passButton, self.superLikeButton
            ])
        c.translatesAutoresizingMaskIntoConstraints = false
        c.spacing = 20
        c.distribution = .fillEqually
        return c
    }()
    
    
    override func setUpViews() {
        
       addSubview(container)
            
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.widthAnchor.constraint(equalTo: widthAnchor),
            container.heightAnchor.constraint(equalTo: heightAnchor)
            ])
    }
    
    @objc func like() {
        print("like print")
    }
    
    @objc func pass() {
    
        print("pass print")
    }
    
    @objc func superLike() {
        print("super like print")
    }
    
    
}
