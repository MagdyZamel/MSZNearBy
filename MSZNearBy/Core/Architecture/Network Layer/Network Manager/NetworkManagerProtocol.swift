//
//  NetworkManagerProtocol.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

protocol NetworkManagerProtocol: class {
    func perform<T: Codable>(apiRequest: APIRequestProtocol,
                             providerType: APIRequestProviderProtocol,
                             outputType: T.Type) -> Promise<T>
}
