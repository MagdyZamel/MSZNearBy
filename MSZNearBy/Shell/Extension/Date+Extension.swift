//
//  Date+Extension.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

enum DateFormat: String {
    case date = "yyyyMMdd"
}
extension Date {
    func stringValue(dateFormat: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        dateFormatter.locale = Locale(identifier: "en")
        return  dateFormatter.string(from: self)
    }
}
