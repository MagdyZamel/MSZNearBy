//
//  BaseUseCase.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

class BaseUseCase {
    
    // Injected by UseCase consumer (e.g. presenter)
    var willProcess: (() -> Void)?
    
    func extract() {}
    func validate() throws {}
    func process<T: Codable>(_ outputType: T.Type) -> Promise<T> {
        return Promise<T>.init(NSError(domain: "Error", code: 100, userInfo: nil))
    }
    
    final func execute<T: Codable>(_ outputType: T.Type) -> Promise<T> {
        do {
            extract()
            try validate()
            willProcess?()
            return process(outputType)
        } catch let error {
            return Promise<T>.init(error)
        }
    }
    
}
