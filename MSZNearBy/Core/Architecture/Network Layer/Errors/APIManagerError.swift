//
//  APIManagerError.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

enum APIManagerError: Error {
    case requestFailed(message: String)
    case errorModel(errorModel: ErrorModel)
    case noInternet(message: String)
   
    var message: String {
        switch self {
        case .requestFailed(let message):
            return message
        case .errorModel(let errorModel):
            return errorModel.errorDetail ?? ""
        case .noInternet(let message):
            return message
        }
    }
}

extension Error {
    var message: String {
        if let apiError = self as? APIManagerError {
            return apiError.message
        } else if let apiError = self as? APIRequestProviderError {
            return apiError.reseon
            
        } else {
            let error = self as NSError
             return error.domain
        }
    }
}
