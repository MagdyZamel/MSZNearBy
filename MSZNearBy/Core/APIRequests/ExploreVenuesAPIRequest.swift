//
//  ExploreVenuesAPIRequest.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

class ExploreVenuesAPIRequest: BaseAPIRequest {
    
    var clientSecret: String
    var clientId: String
    var longLate: String
    var stringDate: String
    var limit: Int
    var offset: Int
    var radius: Int

    init(longLate: String, radius: Int, offset: Int, limit: Int) {
        self.clientSecret = "\(Environment().configuration(.clientSecret))"
        self.clientId = "\(Environment().configuration(.clientId))"
        self.longLate = longLate
        self.stringDate =  Date().stringValue(dateFormat: .date)
        self.limit = limit
        self.offset = offset
        self.radius = radius
        super.init()
        path = "/v2/venues/explore"
    }
    override func queryParams() -> [String: String]? {

        return ["client_secret": "\(clientSecret)",
                "client_id": "\(clientId)",
                "v": "\(stringDate)",
                "ll": "\(longLate)",
                "limit": "\(limit)",
                "offset": "\(offset)",
                "radius": "\(radius)"
        ]
    }
}
