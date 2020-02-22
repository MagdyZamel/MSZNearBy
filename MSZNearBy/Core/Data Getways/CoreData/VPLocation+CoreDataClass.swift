//
//  VPLocation+CoreDataClass.swift
//  MSZNearBy
//
//  Created by MSZ on 12/10/19.
//  Copyright © 2019 MSZ. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VPLocation)
public class VPLocation: NSManagedObject {

    convenience init( lat: Double, long: Double, venues: Set<VenueEntity>) {
        self.init( lat: lat, long: long)
        self.photos = Set<VenuePhotoEntity>.init()
        self.venues = venues

    }
    convenience init(lat: Double, long: Double, photos: Set<VenuePhotoEntity>) {
        self.init( lat: lat, long: long)
        self.photos = photos
        self.venues = Set<VenueEntity>.init()

    }

    convenience init( lat: Double, long: Double) {
        self.init(entity: VPLocation.entity(), insertInto: nil)
        self.lat = lat
        self.long = long
    }

}
