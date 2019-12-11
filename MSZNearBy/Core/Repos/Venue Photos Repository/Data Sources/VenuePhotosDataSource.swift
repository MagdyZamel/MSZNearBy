//
//  VenuePhotosDataSource.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

protocol VenuePhotosDataSource: class {

    func getPhoto(location: LocationCoordinates, venueId: String ) -> Promise<VenuePhotoEntity>
    @discardableResult
    func savePhoto(location: LocationCoordinates, venuePhoto: VenuePhotoEntity) ->  Promise<Void>

}
