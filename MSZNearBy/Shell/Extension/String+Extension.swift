//
//  String+Extension.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
