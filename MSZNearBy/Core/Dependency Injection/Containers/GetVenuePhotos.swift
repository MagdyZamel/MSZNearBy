//
//  GetVenuePhotos.swift
//  MSZNearBy
//
//  Created by MSZ on 2/19/20.
//  Copyright © 2020 MSZ. All rights reserved.
//

import Foundation
extension Resolver {
    static func setupUseCases() {
        register { GetVenuePhotosUseCase(venuePhotosRepo: resolve()) as GetVenuePhotosUseCaseProtocol}
        register { GetVenuesUseCase(venuesRepo: resolve(), locationManager: resolve()) as GetVenuesUseCaseProtocol}
    }
    static func setupPresenters() {
        register { VenuesPresenter(useCase: resolve()) as VenuesPresenterProtocol}
        register { (_, args) -> VenueCellPresenterProtocol in
            let args = args as! [Any]
            let venueCellPresenter =  VenueCellPresenter(useCase: resolve())
            venueCellPresenter.location = args[0] as? LocationCoordinates
            venueCellPresenter.venue = args[1] as? VenueEntity
            return venueCellPresenter
        }
    }

    static func setupViewControllers() {
        register { VenuesVC() }
    }
}
