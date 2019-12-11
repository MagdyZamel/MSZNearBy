//
//  VenuesDataSource.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import  Promises

protocol VenuesDataSourceProtocal: class {
    func getVenues(location: LocationCoordinates, radius: Int, offset: Int, limit: Int) -> Promise<[VenueEntity]>
    @discardableResult
    func save(location: LocationCoordinates, venues: [VenueEntity]) -> Promise<Void>
}
