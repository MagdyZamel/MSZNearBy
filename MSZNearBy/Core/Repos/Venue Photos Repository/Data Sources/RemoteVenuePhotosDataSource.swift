//
//  RemoteVenuePhotosDataSource.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

class RemoteVenuePhotosDataSource: VenuePhotosDataSource {

    @Injected var network: NetworkManagerProtocol
    var providers: [APIRequestProviderProtocol] = [Resolver.resolve()]

    func getPhoto(location: LocationCoordinates, venue: VenueEntity) -> Promise<VenuePhotoEntity> {
        let apiRequest = VenuePhotosAPIRequest(venueId: venue.venueId)
        let promise = Promise<VenuePhotoEntity>.pending()
            network.perform(apiRequest: apiRequest,
                            providerType: providers[0],
                            outputType: APIVenuePhotosResponseModel.self)
            .then({ (response)  in
                let venuePhoto = response.photos?.items?.map({ VenuePhotoEntity(venueId: venue.venueId,
                                                                                venuePhoto: $0) }) ?? []
                if let photo = venuePhoto.first {
                    promise.fulfill(photo)
                }
                promise.fulfill(VenuePhotoEntity())
            })
            .catch({
                promise.reject($0)
            })
        return promise

    }

    func savePhoto(_ venuePhoto: VenuePhotoEntity, inLocation location: LocationCoordinates,
                   forVenue venue: VenueEntity)  -> Promise<Void> {
        return Promise(NSError(domain: "saveingNotAllowed".localized, code: 500, userInfo: nil))
    }

}
