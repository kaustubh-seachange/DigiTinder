//
//  DigiTinderView.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit

class DigiTinderView : UIView {
   
    //MARK: - Properties
    let baseView = UIView()

    var firstView : UIView!
    var shadowView : UIView!
    var imageView: UIImageView!
  
    var nameLabel = UILabel()
    var subLabel = UILabel()
    var moreButton = UIButton()
    
    var delegate : DigiTinderViewDelegate?

    var divisor : CGFloat = 0
    
    var dataSource : DigiTinderSwipeModel? {
        didSet {
            firstView.backgroundColor = dataSource?.bgColor
            nameLabel.text = dataSource?.text
            subLabel.text = dataSource?.subText
            guard let image = dataSource?.image else { return }
            imageView.load(url: image) 
        }
    }
    
    //MARK: - Init
     override init(frame: CGRect) {
        super.init(frame: .zero)
        configureShadowView()
        configureSwipeView()
        configureLabelView()
        configureSubLabelView()
        configureImageView()
        configureButton()
        addPanGestureOnCards()
        configureTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration
    
    func configureShadowView() {
        shadowView = UIView()
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 4.0
        addSubview(shadowView)
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        shadowView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    func configureSwipeView() {
        firstView = UIView()
        firstView.layer.cornerRadius = 15
        firstView.clipsToBounds = true
        shadowView.addSubview(firstView)
        
        firstView.translatesAutoresizingMaskIntoConstraints = false
        firstView.leftAnchor.constraint(equalTo: shadowView.leftAnchor).isActive = true
        firstView.rightAnchor.constraint(equalTo: shadowView.rightAnchor).isActive = true
        firstView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
        firstView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
    }
    
    func configureLabelView() {
        firstView.addSubview(nameLabel)
        nameLabel.backgroundColor = .white
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 24)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: firstView.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: firstView.rightAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: firstView.bottomAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 85).isActive = true
    }
    
    func configureSubLabelView() {
        firstView.addSubview(subLabel)
        subLabel.backgroundColor = .white
        subLabel.textColor = .black
        subLabel.textAlignment = .center
        subLabel.font = UIFont.systemFont(ofSize: 18)
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        subLabel.bottomAnchor.constraint(equalTo: firstView.bottomAnchor).isActive = true
        subLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func configureImageView() {
        imageView = UIImageView()
        firstView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: firstView.centerYAnchor, constant: -30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func configureButton() {
        nameLabel.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "plus-tab")?.withRenderingMode(.alwaysTemplate)
        moreButton.setImage(image, for: .normal)
        moreButton.tintColor = UIColor.red
        
        moreButton.rightAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: -15).isActive = true
        moreButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    }

    func configureTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    
    func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    //MARK: - Handlers
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        let card = sender.view as! DigiTinderView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        
        let swapShift = ((UIScreen.main.bounds.width / 2) - card.center.x)
        print("adjust swapShift: \(swapShift); '+'=userDisliked ; '-'=userliked")
        divisor = ((UIScreen.main.bounds.width / 2) / 0.61)
       
        switch sender.state {
        case .ended:
            if (card.center.x) > 400 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }else if card.center.x < -65 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.layoutIfNeeded()
            }
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            
        default:
            break
        }
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer){
        
    }
}
