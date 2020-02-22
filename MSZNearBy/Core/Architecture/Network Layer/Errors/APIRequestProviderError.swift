//
//  APIRequestProviderError.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

enum APIRequestProviderError: Error {
    case noInternet(message: String)
    case server(statusCode: Int, data: Data?)
    case requestFailed(error: Error)

    var reseon: String {
        switch self {
        case .requestFailed (let error):
            return error.localizedDescription
        case .server(let statusCode):
            return "Request Failed with status Code \(statusCode)"
        case .noInternet(let eMessage):
            return eMessage
        }
    }
}
