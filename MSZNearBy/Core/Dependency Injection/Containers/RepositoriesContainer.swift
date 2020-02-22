//
//  Repos .swift
//  MSZNearBy
//
//  Created by MSZ on 2/19/20.
//  Copyright © 2020 MSZ. All rights reserved.
//

import Foundation

extension Resolver {

    static func setupVenuesRepository() {
        register( name: Constants.DIQualifers.remote,
                  factory: { RemoteVenuesDataSource() as VenuesDataSourceProtocal}).scope(Resolver.application)
        register( name: Constants.DIQualifers.local,
                  factory: { LocalVenuesDataSource() as VenuesDataSourceProtocal}).scope(Resolver.application)
        register { VenuesRepository() as VenuesRepositoryProtocal }.scope(Resolver.application)

    }

    static func setupVenuePhotosRepository() {
        register( name: Constants.DIQualifers.remote,
                  factory: { RemoteVenuePhotosDataSource() as VenuePhotosDataSource}).scope(Resolver.application)
        register( name: Constants.DIQualifers.local,
                  factory: { LocalVenuePhotosDataSource() as VenuePhotosDataSource}).scope(Resolver.application)
        register { VenuePhotoRepository() as VenuePhotoRepositoryProtocal}.scope(Resolver.application)
    }

}
