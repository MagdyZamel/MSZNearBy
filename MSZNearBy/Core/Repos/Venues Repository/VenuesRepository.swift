//
//  VenuesRepository.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

protocol VenuesRepositoryProtocal: RepositoryProtocol {
    func getVenues(location: LocationCoordinates, radius: Int, offset: Int, limit: Int) -> Promise<[VenueEntity]>
    
}
class VenuesRepository: VenuesRepositoryProtocal {
    private var mCashedVenues: [VenueEntity]?
    private var localDataSource: VenuesDataSourceProtocal
    private var remoteDataSource: VenuesDataSourceProtocal
    private var mCacheIsDirty = false

    init(localDataSource: VenuesDataSourceProtocal,
         remoteDataSource: VenuesDataSourceProtocal) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func getVenues(location: LocationCoordinates, radius: Int, offset: Int, limit: Int) -> Promise<[VenueEntity]> {
        
        if let mCashedVenues = mCashedVenues, !mCacheIsDirty {
            return .init(mCashedVenues)
        }
        if mCacheIsDirty {
            return getVenuesFromRemote(location: location, radius: radius, offset: offset, limit: limit)
        }
        return getVenuesFromLocal(location: location, radius: radius, offset: offset, limit: limit)
    }
    
    func changeMCacheToDirty() {
        mCacheIsDirty = true
        mCashedVenues = nil
    }
    
    private func  refreshMCashedVenues(_ mCashedVenues: [VenueEntity]) {
        self.mCashedVenues = mCashedVenues
    }
    
    func getVenuesFromLocal(location: LocationCoordinates,
                            radius: Int, offset: Int, limit: Int) -> Promise<[VenueEntity]> {
        let result = Promise<[VenueEntity]>.pending()
        localDataSource.getVenues(location: location, radius: radius, offset: offset, limit: limit
        ).then { [weak self]  venues  in
            self?.refreshMCashedVenues(venues)
            self?.mCacheIsDirty = false
            result.fulfill(venues)
        }.catch { [weak self] (error) in
            self?.mCacheIsDirty = true
            self?.mCashedVenues = nil
            result.reject(error)
        }
        return result
    }
    
    func getVenuesFromRemote(location: LocationCoordinates,
                             radius: Int, offset: Int, limit: Int) -> Promise<[VenueEntity]> {
        let result = Promise<[VenueEntity]>.pending()
        remoteDataSource.getVenues(location: location, radius: radius, offset: offset, limit: limit
        ).then { [weak self]  venues  in
            self?.refreshMCashedVenues(venues)
            self?.mCacheIsDirty = false
            self?.localDataSource.save(location: location, venues: venues)
            result.fulfill(venues)
        }.catch { [weak self] (error) in
            self?.mCacheIsDirty = true
            self?.mCashedVenues = nil
            result.reject(error)
        }
        return result
    }
}
