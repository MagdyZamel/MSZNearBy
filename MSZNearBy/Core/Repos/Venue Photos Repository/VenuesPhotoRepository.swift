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
    @Injected(name: Constants.DIQualifers.local)
    var localDataSource: VenuePhotosDataSource
    @Injected(name: Constants.DIQualifers.remote)
    var remoteDataSource: VenuePhotosDataSource
    private var mCacheIsDirty = [String: Bool]()

    func getPhoto(location: LocationCoordinates, venue: VenueEntity ) -> Promise<VenuePhotoEntity> {
        let mCacheIsDirty  = self.mCacheIsDirty[venue.venueId] ?? false

        if let photo = mCashedPhotos[venue.venueId], !mCacheIsDirty {
            return .init(photo)
        }
        return getPhotoFromLocal(location: location, venue: venue ).recover { (error)-> Promise<VenuePhotoEntity> in
            if Singletons.internetManager.isInternetConnectionAvailable() {
                return self.getPhotoFromRemote(location: location, venue: venue )
            }
            return .init(error)
        }

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
        remoteDataSource.getPhoto(location: location, venue: venue).then { [weak self]  venuePhoto  in
            self?.refreshMCashedPhoto(venuePhoto, venue: venue)
            self?.mCacheIsDirty[venue.venueId] = false
            let stringURL = "\(venuePhoto.prefix)\(venuePhoto.width)x\(venuePhoto.height)\(venuePhoto.suffix)"
            if let url  = URL(string: stringURL) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil
                        else {
                            result.reject(error ?? NSError(domain: "String", code: 21, userInfo: nil))
                            return }
                    venuePhoto.image = data
                    self?.savePhoto(venuePhoto, inLocation: location, forVenue: venue)
                    result.fulfill(venuePhoto)
                }.resume()
            }

        }.catch { [weak self] (error) in
            self?.mCacheIsDirty[venue.venueId] = true
            self?.mCashedPhotos.removeValue(forKey: venue.venueId)
            result.reject(error)
        }
        return result
    }
    @discardableResult
    func savePhoto(_ venuePhoto: VenuePhotoEntity, inLocation location: LocationCoordinates,
                   forVenue venue: VenueEntity) -> Promise<Void> {
        return self.localDataSource.savePhoto(venuePhoto, inLocation: location, forVenue: venue)
    }
}
