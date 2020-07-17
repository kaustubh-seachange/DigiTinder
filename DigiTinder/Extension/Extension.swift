//
//  Extension.swift
//  DigiTinder
//
//  Created by Kaustubh on 27/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import Foundation
import CryptoSwift

extension NSObject {
    func loggerMin(_ message: String, function: String = #function, line: Int = #line) {
        print("{\(function):\(line)} :) \(message)")
    }
    
    func logger(_ message: String,
                file: String = #file,
                function: String = #function,
                line: Int = #line,
                column: Int = #column) {
        print("{\(file)->\(function):\(line)[\(column)]} :) \(message)")
    }
}

extension UIImageView {
    func load(url: String) {
        let requrl = URL(string: url)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: requrl!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension DateFormatter {
    static let fullISO8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension Date{
     var daysInMonth:Int{
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
}

public extension CodingUserInfoKey {
    // Helper property to retrieve the Core Data managed object context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
    static let context = CodingUserInfoKey(rawValue: "context")!
}
