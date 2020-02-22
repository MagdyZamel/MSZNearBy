//
//  BaseUseCase.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

protocol BaseUseCaseProtocol {
    var willProcess: (() -> Void)? {get set}
    func execute<T>(_ outputType: T.Type) -> Promise<T>
}

class BaseUseCase: BaseUseCaseProtocol {

    // Injected by UseCase consumer (e.g. presenter)
    var willProcess: (() -> Void)?

    func extract() {}
    func validate() throws {}
    func process<T>(_ outputType: T.Type) -> Promise<T> {
        return Promise<T>.init(NSError(domain: "Error", code: 100, userInfo: nil))
    }

    final func execute<T>(_ outputType: T.Type) -> Promise<T> {
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
