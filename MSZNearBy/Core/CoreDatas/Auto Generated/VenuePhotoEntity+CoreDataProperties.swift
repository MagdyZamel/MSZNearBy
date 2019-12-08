//
//  VenuePhotoEntity+CoreDataProperties.swift
//  MSZNearBy
//
//  Created by MSZ on 12/8/19.
//  Copyright © 2019 MSZ. All rights reserved.
//
//

import Foundation
import CoreData

extension VenuePhotoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VenuePhotoEntity> {
        return NSFetchRequest<VenuePhotoEntity>(entityName: "VenuePhoto")
    }

    @NSManaged public var height: NSDecimalNumber?
    @NSManaged public var image: Data?
    @NSManaged public var photoId: String?
    @NSManaged public var prefix: String?
    @NSManaged public var suffix: String?
    @NSManaged public var width: NSDecimalNumber?
    @NSManaged public var photo: VenuePhotoEntity?

}
