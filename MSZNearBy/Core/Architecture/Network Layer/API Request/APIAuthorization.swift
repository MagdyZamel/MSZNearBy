//
//  APIAuthorization.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

enum APIAuthorization {
    case none
    case bearerToken
    var authData: Any {
        switch self {
        case .none:
            return []
        case .bearerToken:
            let token  = ""
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
