//
//  RemoteVenuesDataSource.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

class RemoteVenuesDataSource: VenuesDataSourceProtocal {
    
    let network: NetworkManagerProtocol
    let providers: [APIRequestProviderProtocol]
    
    init(network: NetworkManagerProtocol, providers: [APIRequestProviderProtocol] ) {
        self.network = network
        self.providers = providers
    }
    
    func getVenues(location: LocationCoordinates,
                   radius: Int,
                   offset: Int,
                   limit: Int) -> Promise<[VenueEntity]> {
        let longLate = "\(location.lat),\(location.long)"
        let apiRequest = ExploreVenuesAPIRequest(longLate: longLate, radius: radius, offset: offset, limit: limit)
        let promise = Promise<[VenueEntity]>.pending()
            network.perform(apiRequest: apiRequest,
                            providerType: providers[0],
                            outputType: APIExploreResponseModel.self)
            .then({ (response)  in
                let venues = response.groups?[0].items?.map({VenueEntity(venue: $0.venue)}) ?? []
                promise.fulfill(venues)
            })
            .catch({
                promise.reject($0)
            })
        return promise
    }
    
    func save(location: LocationCoordinates, venues: [VenueEntity]) -> Promise<Void> {
        return Promise(NSError(domain: "saveingNotAllowed".localized, code: 500, userInfo: nil))
    }
}
