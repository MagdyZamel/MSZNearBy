//
//  DataBaseProtocoll.swift
//  MSZNearBy
//
//  Created by MSZ on 12/7/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

public protocol DataBaseProtocol {

    // Clears all records
    func clear() -> Promise<Void>
    func start() -> Promise<Void>
}
