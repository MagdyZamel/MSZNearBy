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
    
    func getPhoto(location: LocationCoordinates, venueId: String) -> Promise<VenuePhotoEntity> {
        let query: NSFetchRequest = VenuePhotoEntity.fetchRequest()
        let pin = Promise<VenuePhotoEntity>.pending()
        dataBaseManager.fetch(query: query, output: VenuePhotoEntity.self).then { (venuePhotos)  in
            pin.fulfill(venuePhotos.first!)
        }.catch(pin.reject(_:))
        return pin
    }
    
    func savePhoto(location: LocationCoordinates, venuePhoto: VenuePhotoEntity) -> Promise<Void> {
        return dataBaseManager.insert(data: venuePhoto)
    }
}
