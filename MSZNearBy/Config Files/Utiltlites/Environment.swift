//
//  Environment.swift
//  MSZNearBy
//
//  Created by MSZ on 12/5/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
public struct Environment {

    fileprivate var infoDict: [String: Any] {
            if let dict = Bundle.main.infoDictionary {
                return dict
            } else {
                fatalError("Plist file not found")
            }
    }
    public func configuration(_ key: PlistKey) -> NSString {
        guard let key = infoDict[key.value()] as? NSString else {
            fatalError("Key Not founded")
        }
        return key
    }
}
