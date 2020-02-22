//
//  APIExploreResponseModelMocker.swift
//  ExlporeVenuesTests
//
//  Created by MSZ on 12/15/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
@testable import MSZNearBy
import Promises

class APIExploreResponseModelMocker {

    static func createFake(fromcontext context: AnyObject) -> APIExploreResponseModel {
        let bundlUrl = Bundle(for: type(of: context))
        let path = bundlUrl.path(forResource: "ExploreVenuesResponse", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        let decoder = JSONDecoder()
        if let data = data,
            let fake =  try? decoder.decode(APIExploreResponseModel.self, from: data) {
            return fake
        }
        fatalError()
    }
}
