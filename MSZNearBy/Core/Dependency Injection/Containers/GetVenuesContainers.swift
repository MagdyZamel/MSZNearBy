//
//  VenuesContainers.swift
//  MSZNearBy
//
//  Created by MSZ on 2/19/20.
//  Copyright © 2020 MSZ. All rights reserved.
//

import Foundation
extension Resolver {
    static func setupGetVenuesContainers() {
        register { GetVenuesUseCase() as GetVenuesUseCaseProtocol}
        register { VenuesPresenter() as VenuesPresenterProtocol}
        register { VenuesVC() }

    }
    static func setupGetVenuePhotosContainers() {
        register { GetVenuePhotosUseCase() as GetVenuePhotosUseCaseProtocol}
        register { (_, args) -> VenueCellPresenterProtocol in
            let args = args as! [Any]
            let venueCellPresenter =  VenueCellPresenter()
            venueCellPresenter.location = args[0] as? LocationCoordinates
            venueCellPresenter.venue = args[1] as? VenueEntity
            return venueCellPresenter
        }
    }
}
