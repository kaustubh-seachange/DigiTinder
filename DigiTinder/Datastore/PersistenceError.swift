//
//  PersistenceError.swift
//  DigiTinder
//
//  Created by Kaustubh on 25/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation

enum PersistenceError: Error {
    case managedObjectContextNotFound
    case couldNotSaveObject
    case objectNotFound
}
