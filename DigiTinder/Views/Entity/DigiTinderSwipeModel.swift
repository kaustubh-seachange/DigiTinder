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
    
    var name : String
    var subText: String
    
    var dob: String
    var email: String

    var city: String
    var state: String
    var zip: String
    
    var phone: String
    var cell: String
    var privacyInfo: String
    var isMarkedFavourite: Bool
    
    init(bgColor: UIColor, image: String, name: String, subText: String, dob: String, email: String, city: String, state: String, zip: String, phone: String, cell: String, privacyInfo: String, isMarkedFavourite: Bool) {
        self.bgColor = bgColor
        self.image = image
        self.name = name
        self.subText = subText
        self.dob = dob
        self.email = email
        self.city = city
        self.state = state
        self.zip = zip
        self.phone = phone
        self.cell = cell
        self.privacyInfo = privacyInfo
        self.isMarkedFavourite = isMarkedFavourite
    }

}
