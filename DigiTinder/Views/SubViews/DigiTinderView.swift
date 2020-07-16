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
    var shadowView : UIView!
    
    var topView : UIView!
    var bottomView: UIView!
    
    var viewForImage: UIView!
    var linViewForImage: UIView!
    var imageView: UIImageView!
    
    var nameLabel = UILabel()
    var subLabel = UILabel()
    
    var locationButton = UIButton() // MARK: This is centrally aligned button.
    var emailButton = UIButton()
    var nameButton = UIButton()
    var cellButton = UIButton()
    var privacyButton = UIButton()
    var favouriteButton = UIButton()
    
    var delegate : DigiTinderViewDelegate?

    var divisor : CGFloat = 0
    
    var dataSource : DigiTinderSwipeModel? {
        didSet {
            print("dataSource.name: \(String(describing: dataSource?.name))")
            topView.backgroundColor = dataSource?.bgColor
            nameLabel.text = dataSource?.name
            subLabel.text = dataSource?.subText
            nameButton.isSelected = true
            if dataSource!.isMarkedFavourite {
                favouriteButton.isSelected = true
            }
            //guard let image = dataSource?.image else { return }
            //imageView.load(url: image)
            imageView.resourceCachingFrom(dataSource!.image,
                                          placeHolder:UIImage(named: "placeholder"))
        }
    }
    
    //MARK: - Init
     override init(frame: CGRect) {
        super.init(frame: .zero)
        configureShadowView()
        configureTopView()
        configureBottomView()
        configureLabelView()
        configureSubLabelView()
        configureImageView()
        configureFavouriteButton()
        configureButtons()
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
        shadowView.layer.shadowRadius = 2.0
        addSubview(shadowView)
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        shadowView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    func configureTopView() {
        topView = UIView()
        topView.backgroundColor = .yellow
        topView.layer.cornerRadius = 15
        topView.clipsToBounds = true
        shadowView.addSubview(topView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.leftAnchor.constraint(equalTo: shadowView.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: shadowView.rightAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
    }
    
    func configureBottomView() {
        bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.layer.borderColor = UIColor.lightGray.cgColor
        bottomView.layer.borderWidth = 1.0
        bottomView.layer.cornerRadius = 15
        bottomView.clipsToBounds = true
        shadowView.addSubview(bottomView)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leftAnchor.constraint(equalTo: shadowView.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: shadowView.rightAnchor).isActive = true
        
        bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: -100).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func configureImageView() {
        viewForImage = UIView()
        viewForImage.backgroundColor = .white
        viewForImage.layer.borderColor = UIColor.lightGray.cgColor
        viewForImage.layer.borderWidth = 1.0
        viewForImage.layer.cornerRadius = 80
        viewForImage.clipsToBounds = true
        shadowView.addSubview(viewForImage)
        viewForImage.translatesAutoresizingMaskIntoConstraints = false
        viewForImage.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        viewForImage.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: -100).isActive = true
        viewForImage.widthAnchor.constraint(equalToConstant: 160).isActive = true
        viewForImage.heightAnchor.constraint(equalToConstant: 160).isActive = true

        linViewForImage = UIView()
        linViewForImage.backgroundColor = .white
        linViewForImage.layer.borderColor = UIColor.lightGray.cgColor
        linViewForImage.layer.borderWidth = 1.0
        topView.addSubview(linViewForImage)
        linViewForImage.translatesAutoresizingMaskIntoConstraints = false
        linViewForImage.centerXAnchor.constraint(equalTo: viewForImage.centerXAnchor).isActive = true
        linViewForImage.centerYAnchor.constraint(equalTo: viewForImage.centerYAnchor, constant:  40).isActive = true
        linViewForImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        linViewForImage.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        imageView = UIImageView()
        //imageView.frame = CGRect.init(x: 0, y: 0, width: 120, height: 120)
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.clipsToBounds = true
        viewForImage.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: viewForImage.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: viewForImage.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func configureLabelView() {
        topView.addSubview(nameLabel)
        nameLabel.backgroundColor = .white
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 20).isActive = true

        nameLabel.leftAnchor.constraint(equalTo: topView.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: topView.rightAnchor).isActive = true
//        nameLabel.bottomAnchor.constraint(equalTo: firstView.bottomAnchor).isActive = true
//        nameLabel.heightAnchor.constraint(equalToConstant: 85).isActive = true
    }
    
    func configureSubLabelView() {
        topView.addSubview(subLabel)
        subLabel.backgroundColor = .white
        subLabel.textColor = .black
        subLabel.textAlignment = .center
        subLabel.font = UIFont.systemFont(ofSize: 11)
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        subLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        subLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        subLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
    }
    
    func configureFavouriteButton() {
        // MARK: Favourite Button.
        topView.addSubview(favouriteButton)
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        let favouriteimage = UIImage(named: "notliked")?.withRenderingMode(.alwaysTemplate)
        favouriteButton.setImage(favouriteimage, for: .normal)
        let selfavouriteimage = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        favouriteButton.setImage(selfavouriteimage, for: .selected)
        favouriteButton.tag = 10
        favouriteButton.addTarget(self, action: #selector(markProfileFavouriteAction), for: .touchUpInside)
        favouriteButton.leftAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -50).isActive = true
        favouriteButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: -10).isActive = true
        favouriteButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        favouriteButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
    
    func configureButtons() {
        // MARK: Setting the Centrally aligned button and then layout left/right Button, assumed location as central button, while rightSide Buttons(call, privacy) and leftSide Buttons(userdetails, otherInfo)
        
        // MARK: Location Button.
        bottomView.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        let locationimage = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
        locationButton.setImage(locationimage, for: .normal)
        let sellocationimage = UIImage(named: "sellocation")?.withRenderingMode(.alwaysTemplate)
        locationButton.setImage(sellocationimage, for: .selected)
        locationButton.tag = 0
        locationButton.addTarget(self, action: #selector(buttonsAction), for: .touchUpInside)
        locationButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        locationButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        locationButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        locationButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        // MARK: Email Button.
        bottomView.addSubview(emailButton)
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        let emailimage = UIImage(named: "email")?.withRenderingMode(.alwaysTemplate)
        emailButton.setImage(emailimage, for: .normal)
        let selemailimage = UIImage(named: "selemail")?.withRenderingMode(.alwaysTemplate)
        emailButton.setImage(selemailimage, for: .selected)
        emailButton.tag = -1
        emailButton.addTarget(self, action: #selector(buttonsAction), for: .touchUpInside)
        emailButton.rightAnchor.constraint(equalTo: locationButton.leftAnchor, constant: 20).isActive = true
        emailButton.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor).isActive = true
        emailButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        emailButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        // MARK: Name Button.
        bottomView.addSubview(nameButton)
        nameButton.translatesAutoresizingMaskIntoConstraints = false
        let nameimage = UIImage(named: "user")?.withRenderingMode(.alwaysTemplate)
        nameButton.setImage(nameimage, for: .normal)
        let selnameimage = UIImage(named: "seluser")?.withRenderingMode(.alwaysTemplate)
        nameButton.setImage(selnameimage, for: .selected)
        nameButton.tag = -2
        nameButton.addTarget(self, action: #selector(buttonsAction), for: .touchUpInside)
        nameButton.rightAnchor.constraint(equalTo: emailButton.leftAnchor, constant: 20).isActive = true
        nameButton.centerYAnchor.constraint(equalTo: emailButton.centerYAnchor).isActive = true
        nameButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        nameButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        // MARK: Cell Button.
        bottomView.addSubview(cellButton)
        cellButton.translatesAutoresizingMaskIntoConstraints = false
        let cellimage = UIImage(named: "call")?.withRenderingMode(.alwaysTemplate)
        cellButton.setImage(cellimage, for: .normal)
        let selcellimage = UIImage(named: "selcall")?.withRenderingMode(.alwaysTemplate)
        cellButton.setImage(selcellimage, for: .selected)
        cellButton.tag = 1
        cellButton.addTarget(self, action: #selector(buttonsAction), for: .touchUpInside)
        cellButton.leftAnchor.constraint(equalTo: locationButton.rightAnchor, constant: -20).isActive = true
        cellButton.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor).isActive = true
        cellButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        cellButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        // MARK: Privacy Button.
        bottomView.addSubview(privacyButton)
        privacyButton.translatesAutoresizingMaskIntoConstraints = false
        let privacyimage = UIImage(named: "privacy")?.withRenderingMode(.alwaysTemplate)
        privacyButton.setImage(privacyimage, for: .normal)
        let selprivacyimage = UIImage(named: "selprivacy")?.withRenderingMode(.alwaysTemplate)
        privacyButton.setImage(selprivacyimage, for: .selected)
        //privacyButton.tintColor = UIColor.lightGray
        privacyButton.tag = 2
        privacyButton.addTarget(self, action: #selector(buttonsAction), for: .touchUpInside)
        privacyButton.leftAnchor.constraint(equalTo: cellButton.rightAnchor, constant: -20).isActive = true
        privacyButton.centerYAnchor.constraint(equalTo: cellButton.centerYAnchor).isActive = true
        privacyButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        privacyButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
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
        //let swapShift = ((UIScreen.main.bounds.width / 2) - card.center.x)
        //print("adjust swapShift: \(swapShift); '+'=userDisliked ; '-'=userliked")
        divisor = ((UIScreen.main.bounds.width / 2) / 0.61)
       
        switch sender.state {
        case .ended:
            if (card.center.x) > 400 {
                delegate?.swipeDidEnd(on: card, isFavourite: true, profiledData: dataSource!)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }else if card.center.x < -65 {
                delegate?.swipeDidEnd(on: card, isFavourite: false, profiledData: dataSource!)
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
    
    // MARK: - Button Action(s).
    @objc func markProfileFavouriteAction(sender: UIButton) {
        print("sender.tag: \(sender.tag)")
        let btn = sender as UIButton
        favouriteButton.isSelected = btn.isSelected
        self.delegate?.userTapped(profile: btn.isSelected, for: dataSource!)
    }
    
    @objc func buttonsAction(sender: UIButton) {
        switch sender.tag {
            case -2:
                self.updateInfo(for: dataSource!.name, sublblAs: dataSource!.subText)
            case -1:
                self.updateInfo(for: dataSource!.dob, sublblAs: dataSource!.email)
            case 1:
                self.updateInfo(for: dataSource!.cell, sublblAs: dataSource!.phone)
            case 2:
                self.updateInfo(for: dataSource!.privacyInfo, sublblAs: "")
            default:
                self.updateInfo(for: dataSource!.city.capitalizingFirstLetter(), sublblAs: "\(dataSource!.zip), \(dataSource!.state.capitalizingFirstLetter())")
        }
        self.updateButtonSelectionState(tag: sender.tag)
    }
    
    @objc func updateInfo(for lblWith: String, sublblAs: String) {
        DispatchQueue.main.async {
            self.nameLabel.text = lblWith
            self.subLabel.text = sublblAs
        }
    }
    
    @objc func updateButtonSelectionState(tag: Int) {
        let buttons = bottomView.subviews.filter({$0.isKind(of: UIButton.self)})
        for button in buttons as! [UIButton]  {
            button.isSelected = (button.tag == tag) ? true : false
        }
    }
}
