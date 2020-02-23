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

    private var mCashedVenues = [String: [VenueEntity]]()
    private var localDataSource: VenuesDataSourceProtocal
    private var remoteDataSource: VenuesDataSourceProtocal
    private var mCacheIsDirty = [String: Bool]()

    init(localDataSource: VenuesDataSourceProtocal,
         remoteDataSource: VenuesDataSourceProtocal) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func getVenues(location: LocationCoordinates, radius: Int, offset: Int, limit: Int) -> Promise<[VenueEntity]> {
//        let longlat = "\(location.long),\(location.lat)"
//        let mCacheIsDirty = self.mCacheIsDirty[longlat] ?? true
//        if let cachedVenues = mCashedVenues[longlat], !mCacheIsDirty {
//            return .init(cachedVenues)
//        }
        return getVenuesFromLocal(location: location,
                                  radius: radius,
                                  offset: offset, limit: limit).recover { (error)-> Promise<[VenueEntity]> in
            if Singletons.internetManager.isInternetConnectionAvailable() {
                return self.getVenuesFromRemote(location: location, radius: radius, offset: offset, limit: limit)
            }
            return .init(error)
        }
    }

    func changeMCacheToDirty() {
        mCacheIsDirty.removeAll()
        mCashedVenues.removeAll()
    }

    private func  refreshMCashedVenues(_ location: LocationCoordinates, mCashedVenues: [VenueEntity]) {
        let longlat = "\(location.long),\(location.lat)"
        self.mCashedVenues[longlat] = mCashedVenues
    }

    func getVenuesFromLocal(location: LocationCoordinates,
                            radius: Int, offset: Int, limit: Int) -> Promise<[VenueEntity]> {
        let longlat = "\(location.long),\(location.lat)"
        let result = Promise<[VenueEntity]>.pending()
        localDataSource.getVenues(location: location, radius: radius, offset: offset, limit: limit
        ).then { [weak self]  venues  in
            self?.refreshMCashedVenues(location, mCashedVenues: venues)
            self?.mCacheIsDirty[longlat] = false
            result.fulfill(venues)
        }.catch { [weak self] (error) in
            self?.mCacheIsDirty.removeValue(forKey: longlat)
            self?.mCashedVenues.removeValue(forKey: longlat)
            result.reject(error)
        }
        return result
    }

    func getVenuesFromRemote(location: LocationCoordinates,
                             radius: Int, offset: Int, limit: Int) -> Promise<[VenueEntity]> {
        let longlat = "\(location.long),\(location.lat)"
        let result = Promise<[VenueEntity]>.pending()

        remoteDataSource.getVenues(location: location,
                                   radius: radius,
                                   offset: offset,
                                   limit: limit).then { [weak self]  venues  in

                self?.refreshMCashedVenues(location, mCashedVenues: venues)
                self?.mCacheIsDirty[longlat] = false
                self?.localDataSource.save(location: location, venues: venues)
                result.fulfill(venues)
            }.catch { [weak self] (error) in
                self?.mCacheIsDirty.removeValue(forKey: longlat)
                self?.mCashedVenues.removeValue(forKey: longlat)
                result.reject(error)
        }
        return result
    }
}
