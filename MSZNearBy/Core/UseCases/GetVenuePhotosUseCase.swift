//
//  GetVenuePhotosUseCase.swift
//  MSZNearBy
//
//  Created by MSZ on 12/12/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

protocol GetVenuePhotosUseCaseProtocol: BaseUseCaseProtocol {
    var venuePhotosRepo: VenuePhotoRepositoryProtocal {get set}
    func update(location: LocationCoordinates, venueEntity: VenueEntity)
}

class GetVenuePhotosUseCase: BaseUseCase, GetVenuePhotosUseCaseProtocol {

    private var venueEntity: VenueEntity!
    private var location: LocationCoordinates!
    private var photo: VenuePhotoEntity?
    @Injected  var venuePhotosRepo: VenuePhotoRepositoryProtocal

    func update(location: LocationCoordinates, venueEntity: VenueEntity) {
        self.location = location
        self.venueEntity = venueEntity
    }

    override func process<T>(_ outputType: T.Type) -> Promise<T> {

        if let photo = self.photo as? T, nil == self.photo?.image {
            return .init(photo)
        }
        let resultPromise = Promise<T>.pending()
        venuePhotosRepo.getPhoto(location: location, venue: venueEntity).then {[weak self] (photo)  in
            self?.photo = photo
            if let usecase = self,
                let photo = usecase.photo {
                if let output = photo as? T {
                    resultPromise.fulfill(output)
                } else {
                    fatalError("unexpected type")
                }
            }
        }.catch(resultPromise.reject(_:))
        return resultPromise

    }
}
