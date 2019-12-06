//
//  VenuePhotosAPIRequest.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

class VenuePhotosAPIRequest: BaseAPIRequest {
    
    var clientSecret: String
    var clientId: String
    var stringDate: String
    var venueId: String
    var limit: Int
    
    init(venueId: String) {
        self.clientSecret = "\(Environment().configuration(.clientSecret))"
        self.clientId = "\(Environment().configuration(.clientId))"
        self.venueId = venueId
        self.stringDate =  Date().stringValue(dateFormat: .date)
        self.limit = 1
        super.init()
        path = "/v2/venues/\(venueId)/photos"
    }
    override func queryParams() -> [String: String]? {

        return ["client_secret": "\(clientSecret)",
                "client_id": "\(clientId)",
                "v": "\(stringDate)",
                "limit": "\(limit)"
        ]
    }
}
