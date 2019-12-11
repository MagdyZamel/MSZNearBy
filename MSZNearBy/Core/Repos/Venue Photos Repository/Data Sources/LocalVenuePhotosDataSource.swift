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
    
    let dataBaseManager: DataBaseManagerProtocol
    
    init(dataBaseManager: DataBaseManagerProtocol) {
        self.dataBaseManager = dataBaseManager
    }
    
    //    func getVenues(location: LocationCoordinates,
    //                   radius: Int, offset: Int, limit: Int) -> Promise<[VenueEntity]> {
    //        let result = Promise<[VenueEntity]>.pending()
    //        let query: NSFetchRequest = VPLocation.fetchRequest()
    //        let allLocationPredicate = NSPredicate { ( expexted, _ ) -> Bool in
    //            guard let vpLocation = expexted as? VPLocation else {
    //                fatalError()
    //            }
    //            let secendLocation = LocationCoordinates(lat: vpLocation.lat, long: vpLocation.long)
    //            let distance = location.distance(from: secendLocation )
    //            return distance < Constants.userRadius*2.0
    //        }
    //        let filterPredicate = NSPredicate { ( expexted, _ ) -> Bool in
    //            guard let venue = expexted as? VenueEntity else {
    //                fatalError()
    //            }
    //            let secendLocation = LocationCoordinates(lat: venue.lat, long: venue.long)
    //            let distance = location.distance(from: secendLocation )
    //            return distance <= Constants.userRadius*2.0
    //        }
    //
    //        dataBaseManager.fetch(query: query, output: VPLocation.self).then { (locations) in
    //            let fillterdLocation = locations.filter(allLocationPredicate.evaluate(with:))
    //            var allVenues = [VenueEntity]()
    //            fillterdLocation.forEach { vpLocations in
    //                let venues: [VenueEntity] = vpLocations.venues.filter(filterPredicate.evaluate(with:))
    //                allVenues.append(contentsOf: venues)
    //            }
    //            result.fulfill(allVenues)
    //        }.catch(result.reject(_:))
    //
    //        return result
    //
    //    }
    //

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
                    guard let venue = expexted as? VenueEntity else {
                        fatalError()
                    }
                    let secendLocation = LocationCoordinates(lat: venue.lat, long: venue.long)
                    let distance = location.distance(from: secendLocation )
                    return distance <= Constants.userRadius*2.0
                }
        
                dataBaseManager.fetch(query: query, output: VPLocation.self).then { (locations) in
                    let fillterdLocation = locations.filter(allLocationPredicate.evaluate(with:))
                    var photo: VenuePhotoEntity = VenuePhotoEntity(venue: venue)
                    for vpLocations in fillterdLocation {
                        let photos: [VenuePhotoEntity] =  vpLocations.photos.filter(filterPredicate.evaluate(with:))
                        if photos.count != 0 {
                            photo = photos[0]
                            break
                        }
                    }
                    
                    result.fulfill(photo)
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