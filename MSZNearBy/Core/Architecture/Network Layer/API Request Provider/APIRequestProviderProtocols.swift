//
//  APIRequestProviderProtocols.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

protocol APIRequestProviderProtocol {
    typealias APIRequestCompletion = (_ result: Result<Data, APIRequestProviderError>) -> Void
    func perform(apiRequest: APIRequestProtocol, completion: @escaping APIRequestCompletion)
}
