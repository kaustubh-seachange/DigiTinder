//
//  DTSecureInfo.swift
//  DigiTinder
//
//  Created by Kaustubh on 28/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import CommonCrypto

// MARK: - Data Security
// https://www.raywenderlich.com/129-basic-ios-security-keychain-and-hashing
// Storing certain information in keychain is OOS for Test is concerned, However CryptoSwift Pod is used for encryption of name and pass.
class DTSecureInfo {
    func securePass(using salt: String, name: String, pass: String) -> String {
        return "\(pass).\(name).\(salt)".sha256()
    }
    
    func secureName(using salt: String, name: String) -> String {
        return "\(name).\(salt)".md5()
    }
    
    func other(info: String, using salt: String) -> String {
        return "\(info).\(salt)".sha256()
    }

}


