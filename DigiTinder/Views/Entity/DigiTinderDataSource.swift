//
//  DigiTinderDataSource.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import UIKit

protocol DigiTinderDataSource {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> DigiTinderView
    func emptyView() -> UIView?
}

protocol DigiTinderViewDelegate {
    func swipeDidEnd(on view: DigiTinderView)
}