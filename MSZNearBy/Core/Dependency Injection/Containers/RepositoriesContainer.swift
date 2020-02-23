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
                  factory: { RemoteVenuesDataSource(network: resolve(),
                                                    providers: [resolve()]) as VenuesDataSourceProtocal})
            .scope(Resolver.application)
        register( name: Constants.DIQualifers.local,
                  factory: { LocalVenuesDataSource(dataBaseManager: resolve()) as VenuesDataSourceProtocal})
            .scope(Resolver.application)
        register { VenuesRepository(localDataSource: resolve(name: Constants.DIQualifers.local),
                                    remoteDataSource: resolve(name: Constants.DIQualifers.remote)) as VenuesRepositoryProtocal }
            .scope(Resolver.application)

    }

    static func setupVenuePhotosRepository() {
        register( name: Constants.DIQualifers.remote,
                  factory: { RemoteVenuePhotosDataSource(network: resolve(),
                                                         providers: [resolve()]) as VenuePhotosDataSource})
            .scope(Resolver.application)
        register( name: Constants.DIQualifers.local,
                  factory: { LocalVenuePhotosDataSource(dataBaseManager: resolve()) as VenuePhotosDataSource})
            .scope(Resolver.application)
        register { VenuePhotoRepository(localDataSource: resolve(name: Constants.DIQualifers.local),
                                        remoteDataSource: resolve(name: Constants.DIQualifers.remote)) as VenuePhotoRepositoryProtocal }
            .scope(Resolver.application)
    }

}
