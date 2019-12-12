//
//  VenuePhotoRepository.swift
//  MSZNearBy
//
//  Created by MSZ on 12/11/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

protocol VenuePhotoRepositoryProtocal: RepositoryProtocol {
    
    func getPhoto(location: LocationCoordinates, venue: VenueEntity ) -> Promise<VenuePhotoEntity>
    @discardableResult
    func savePhoto( _ venuePhoto: VenuePhotoEntity,
                    inLocation location: LocationCoordinates,
                    forVenue venue: VenueEntity) -> Promise<Void>
}

class VenuePhotoRepository: VenuePhotoRepositoryProtocal {
    
    private var mCashedPhotos = [String: VenuePhotoEntity]()
    private var mVenues = [String: VenueEntity]()
    private var localDataSource: VenuePhotosDataSource
    private var remoteDataSource: VenuePhotosDataSource
    private var mCacheIsDirty = [String: Bool]()

    init(localDataSource: VenuePhotosDataSource,
         remoteDataSource: VenuePhotosDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func getPhoto(location: LocationCoordinates, venue: VenueEntity ) -> Promise<VenuePhotoEntity> {
        let mCacheIsDirty  = self.mCacheIsDirty[venue.venueId] ?? false
        
        if let photo = mCashedPhotos[venue.venueId], !mCacheIsDirty {
            return .init(photo)
        }
        if mCacheIsDirty {
            return getPhotoFromRemote(location: location, venue: venue )
        }
        return getPhotoFromLocal(location: location, venue: venue )

    }
    func changeMCacheToDirty() {
        mCacheIsDirty.removeAll()
        mCashedPhotos.removeAll()
        mVenues.removeAll()
    }
    
    private func refreshMCashedPhoto(_ mCashedPhoto: VenuePhotoEntity, venue: VenueEntity) {
        self.mCashedPhotos[venue.venueId] = mCashedPhoto
        self.mVenues[venue.venueId] = venue
    }
    
    func getPhotoFromLocal(location: LocationCoordinates, venue: VenueEntity ) -> Promise<VenuePhotoEntity> {
        let result = Promise<VenuePhotoEntity>.pending()
        localDataSource.getPhoto(location: location, venue: venue).then { [weak self]  venuePhoto  in
            self?.refreshMCashedPhoto(venuePhoto, venue: venue)
            self?.mCacheIsDirty[venue.venueId] = false
            result.fulfill(venuePhoto)
        }.catch { [weak self] (error) in
            self?.mCacheIsDirty[venue.venueId] = true
            self?.mCashedPhotos.removeValue(forKey: venue.venueId)
            result.reject(error)
        }
        return result
    }
   
    func getPhotoFromRemote(location: LocationCoordinates, venue: VenueEntity ) -> Promise<VenuePhotoEntity> {
        let result = Promise<VenuePhotoEntity>.pending()
        localDataSource.getPhoto(location: location, venue: venue).then { [weak self]  venuePhoto  in
            self?.refreshMCashedPhoto(venuePhoto, venue: venue)
            self?.mCacheIsDirty[venue.venueId] = false
            result.fulfill(venuePhoto)
        }.catch { [weak self] (error) in
            self?.mCacheIsDirty[venue.venueId] = true
            self?.mCashedPhotos.removeValue(forKey: venue.venueId)
            result.reject(error)
        }
        return result
    }
    
    func savePhoto(_ venuePhoto: VenuePhotoEntity, inLocation location: LocationCoordinates,
                   forVenue venue: VenueEntity) -> Promise<Void> {
        return self.localDataSource.savePhoto(venuePhoto, inLocation: location, forVenue: venue)
    }
}
