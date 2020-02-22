//
//  DataBaseManagerProtocol.swift
//  MSZNearBy
//
//  Created by MSZ on 12/7/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

protocol DataBaseManagerProtocol: class {

    // Clears all records
    func clear() -> Promise<Void>
    func start() -> Promise<Void>
    func insert<Input>(data: Input) -> Promise<Void>
    func fetch<Output, Query>(query: Query, output: Output.Type) -> Promise<[Output]>
    func save() -> Promise<Void>
}
