//
//  DigiTinderFoundryView.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import UIKit

class DigiTinderPresenterView: UIView {
    //MARK: - Properties
    var cardsToDisplay: Int = 0
    var cardsVisibleToUser: Int = 1
    var cardViews : [DigiTinderView] = []
    var cardsLeftToLoad: Int = 0
    
    let horizontalSpacing: CGFloat = 10.0
    let verticalSpacing: CGFloat = 10.0
    
    var visibleCards: [DigiTinderView] {
        return subviews as? [DigiTinderView] ?? []
    }
    
    var dataSource: DigiTinderDataSource? {
        didSet {
            reloadData()
        }
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func reloadData() {
        removeAllCardViews()
        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        cardsToDisplay = datasource.numberOfCardsToShow()
        cardsLeftToLoad = cardsToDisplay
        
        for i in 0..<min(cardsToDisplay,cardsVisibleToUser) {
            addCardView(cardView: datasource.card(at: i), atIndex: i )
        }
    }
    
    func reloadData(at index: Int) {
        removeAllCardViews()
        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        cardsToDisplay = datasource.numberOfCardsToShow()
        cardsLeftToLoad = cardsToDisplay
        for i in 0..<min(cardsToDisplay, cardsVisibleToUser) {
            self.loggerMin("i: \(i), index: \(index)")
            addCardView(cardView: datasource.card(at: i), atIndex: i)
        }
    }
    
    func userInteractedWithCard(isFavourite: Bool, profiledData: DigiTinderSwipeModel) {
        // Mark this profile as Favourite and either load next card or invoke API to fetch next profile.
    }
    
    func loadNextCard() {
        
    }

    //MARK: - Configurations
    private func addCardView(cardView: DigiTinderView, atIndex index: Int) {
        cardView.delegate = self
        addCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        cardsLeftToLoad -= 1
    }
    
    func addCardFrame(index: Int, cardView: DigiTinderView) {
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * self.horizontalSpacing)
        let verticalInset = CGFloat(index) * self.verticalSpacing
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
    }
    
    private func removeAllCardViews() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
    
}

extension DigiTinderPresenterView : DigiTinderViewDelegate {
    func swipeDidEnd(on view: DigiTinderView, isFavourite: Bool, profiledData: DigiTinderSwipeModel) {
        dataSource?.markProfile(asFavourite: isFavourite, using: profiledData)

        self.userInteractedWithCard(isFavourite: isFavourite, profiledData: profiledData)
        guard let datasource = dataSource else { return }
        view.removeFromSuperview()

        if cardsLeftToLoad > 0 {
            let newIndex = datasource.numberOfCardsToShow() - cardsLeftToLoad
            addCardView(cardView: datasource.card(at: newIndex), atIndex: 2)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                cardView.center = self.center
                  self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
        }
        else {
            self.loggerMin("cardsleftToLoad: \(cardsLeftToLoad)")
            dataSource?.emptyView()
        }
    }
    
    // MARK: userTapped to Check/Uncheck the Favourite Profile without using Gesture.
    func userTapped(profile asFavourite: Bool, for model: DigiTinderSwipeModel) {
        self.loggerMin("asFavourite: \(asFavourite), model: \(model.email), \(model.phone)")
    }
}
