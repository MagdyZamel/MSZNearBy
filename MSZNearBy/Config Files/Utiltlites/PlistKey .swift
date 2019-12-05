//
//  PlistKey .swift
//  MSZNearBy
//
//  Created by MSZ on 12/5/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

public enum PlistKey {
    case baseDomain
    case timeoutInterval
    case urlProtocol
    case port
    func value() -> String {
        switch self {
        case .baseDomain:
            return "BaseDomain"
        case .timeoutInterval:
            return "TimeoutInterval"
        case .urlProtocol:
            return "URLProtocol"
        case .port:
            return "Port"

        }
    }
}
