//
//  VPLocation+CoreDataProperties.swift
//  MSZNearBy
//
//  Created by MSZ on 12/11/19.
//  Copyright © 2019 MSZ. All rights reserved.
//
//

import Foundation
import CoreData


extension VPLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VPLocation> {
        return NSFetchRequest<VPLocation>(entityName: "VPLocation")
    }

    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var photos: Set<VenuePhotoEntity>
    @NSManaged public var venues: Set<VenueEntity>

}

// MARK: Generated accessors for photos
extension VPLocation {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: VenuePhotoEntity)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: VenuePhotoEntity)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: Set<VenuePhotoEntity>)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: Set<VenuePhotoEntity>)

}

// MARK: Generated accessors for venues
extension VPLocation {

    @objc(addVenuesObject:)
    @NSManaged public func addToVenues(_ value: VenueEntity)

    @objc(removeVenuesObject:)
    @NSManaged public func removeFromVenues(_ value: VenueEntity)

    @objc(addVenues:)
    @NSManaged public func addToVenues(_ values: Set<VenueEntity>)

    @objc(removeVenues:)
    @NSManaged public func removeFromVenues(_ values: Set<VenueEntity>)

}
