//
//  DigiTinderSwipeModel.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import UIKit

struct DigiTinderSwipeModel {
    var image : String
    var bgColor: UIColor
    var text : String
    var subText: String
    init(bgColor: UIColor, image: String, text: String, subText: String) {
        self.bgColor = bgColor
        self.image = image
        self.text = text
        self.subText = subText
    }
}
