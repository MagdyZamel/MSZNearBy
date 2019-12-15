//
//  VenuesRepositorySpy.swift
//  ExlporeVenuesTests
//
//  Created by MSZ on 12/15/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises
@testable import MSZNearBy

class VenuesRepositorySpy: VenuesRepositoryProtocal {
    var isSucceed = false
    
    func getVenues(location: LocationCoordinates, radius: Int, offset: Int, limit: Int) -> Promise<[VenueEntity]> {
        let reselt = Promise<[VenueEntity]>.pending()
        if !isSucceed {
            reselt.reject(GetVenuesError.noVenues)
        } else {
            let apiResponse =  APIExploreResponseModelMocker.createFake(fromcontext: self)
            var venues = [VenueEntity]()
            apiResponse.groups![0].items?.forEach({ (apiItemModel) in
                venues.append(VenueEntity(venue: apiItemModel.venue))
            })
            reselt.fulfill(venues)
        }
        return reselt
    }
    
    func changeMCacheToDirty() { }
    
}
