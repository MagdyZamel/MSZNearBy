//
//  RepositoriesManger.swift
//  MSZNearBy
//
//  Created by MSZ on 12/11/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
class RepositoriesManger {

    let venuesRepo: VenuesRepositoryProtocal
    let venuePhotosRepo: VenuePhotoRepositoryProtocal

    init() {
        let localVenuesDataSource = LocalVenuesDataSource(dataBaseManager: Singletons.coreDataStackManager)
        let remoteVenuesDataSource = RemoteVenuesDataSource(network: Singletons.apiManager,
                                                            providers: [Singletons.apiRequestProvider])
        self.venuesRepo = VenuesRepository(localDataSource: localVenuesDataSource,
                                           remoteDataSource: remoteVenuesDataSource )
        
        let localDataSource = LocalVenuePhotosDataSource(dataBaseManager: Singletons.coreDataStackManager)
        let remoteDataSource = RemoteVenuePhotosDataSource(network: Singletons.apiManager,
        providers: [Singletons.apiRequestProvider])
        venuePhotosRepo = VenuePhotoRepository(localDataSource: localDataSource,
                                               remoteDataSource: remoteDataSource)
    }
}
