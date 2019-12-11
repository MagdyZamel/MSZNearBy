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
    
    let network: NetworkManagerProtocol
    let providers: [APIRequestProviderProtocol]
    
    init(network: NetworkManagerProtocol, providers: [APIRequestProviderProtocol] ) {
        self.network = network
        self.providers = providers
    }

    func getPhoto(location: LocationCoordinates, venueId: String) -> Promise<VenuePhotoEntity> {
        let apiRequest = VenuePhotosAPIRequest(venueId: venueId)
        let promise = Promise<VenuePhotoEntity>.pending()
            network.perform(apiRequest: apiRequest,
                            providerType: providers[0],
                            outputType: APIVenuePhotosResponseModel.self)
            .then({ (response)  in
                let venuePhoto = response.photos?.items?.map({ VenuePhotoEntity(venuePhoto: $0) }) ?? []
                if let photo = venuePhoto.first {
                    promise.fulfill(photo)
                }
                promise.fulfill(VenuePhotoEntity(emptyPhotosWithVenueId: venueId))
            })
            .catch({
                promise.reject($0)
            })
        return promise

    }
    
    func savePhoto(location: LocationCoordinates, venuePhoto: VenuePhotoEntity) ->  Promise<Void> {
        return Promise(NSError(domain: "saveingNotAllowed".localized, code: 121, userInfo: nil))
    }

}
