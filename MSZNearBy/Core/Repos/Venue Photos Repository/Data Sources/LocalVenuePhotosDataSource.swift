//
//  LocalVenuePhotosDataSource.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises
import CoreData

class LocalVenuePhotosDataSource: VenuePhotosDataSource {

    @Injected var dataBaseManager: DataBaseManagerProtocol

    func getPhoto(location: LocationCoordinates, venue: VenueEntity) -> Promise<VenuePhotoEntity> {
                let result = Promise<VenuePhotoEntity>.pending()
                let query: NSFetchRequest = VPLocation.fetchRequest()
                let allLocationPredicate = NSPredicate { ( expexted, _ ) -> Bool in
                    guard let vpLocation = expexted as? VPLocation else {
                        fatalError()
                    }
                    let secendLocation = LocationCoordinates(lat: vpLocation.lat, long: vpLocation.long)
                    let distance = location.distance(from: secendLocation )
                    return distance < Constants.userRadius*2.0
                }
                let filterPredicate = NSPredicate { ( expexted, _ ) -> Bool in
                    guard let venuePhoto = expexted as? VenuePhotoEntity else {
                        fatalError()
                    }

                    return venuePhoto.venueId == venue.venueId
                }
                dataBaseManager.fetch(query: query, output: VPLocation.self).then { (locations) in
                    let fillterdLocation = locations.filter(allLocationPredicate.evaluate(with:))
                    var photo: VenuePhotoEntity?
                    for vpLocations in fillterdLocation {
                        let photos: [VenuePhotoEntity] =  vpLocations.photos.filter(filterPredicate.evaluate(with:))
                        if photos.count != 0 {
                            photo = photos[0]
                            break
                        }
                    }
                    if let photo = photo {
                        result.fulfill(photo)
                    } else {
                        result.reject(NSError(domain: "Not found", code: 404, userInfo: nil))
                    }

                }.catch(result.reject(_:))

                return result
    }

    func savePhoto(_ venuePhoto: VenuePhotoEntity, inLocation location: LocationCoordinates,
                   forVenue venue: VenueEntity)  -> Promise<Void> {
                let query: NSFetchRequest = VPLocation.fetchRequest()
                let result = Promise<Void>.pending()
                let allLocationPredicate = NSPredicate { ( expexted, _ ) -> Bool in
                    guard let vpLocation = expexted as? VPLocation else {
                        fatalError()
                    }
                    let secendLocation = LocationCoordinates(lat: vpLocation.lat, long: vpLocation.long)
                    let distance = location.distance(from: secendLocation )
                    return distance <= Constants.userRadius*2.0
                }
                self.dataBaseManager.insert(data: venuePhoto).then { (_) in
                    self.dataBaseManager.fetch(query: query, output: VPLocation.self).then { (locations) in
                        let fillterdLocation = locations.filter(allLocationPredicate.evaluate(with:))
                        let vplocations = fillterdLocation.first ?? VPLocation(lat: location.lat, long: location.long)
                        vplocations.addToPhotos(venuePhoto)
                        self.dataBaseManager.insert(data: vplocations).then(result.fulfill(_:))
                            .catch(result.reject(_:))
                    }.catch(result.reject(_:))
                }.catch(result.reject(_:))
        return result
    }
}
