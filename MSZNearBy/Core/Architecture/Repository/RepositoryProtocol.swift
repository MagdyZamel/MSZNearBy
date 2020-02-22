//
//  RepositoryProtocol.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

protocol RepositoryProtocol: class {
    func changeMCacheToDirty()
}
