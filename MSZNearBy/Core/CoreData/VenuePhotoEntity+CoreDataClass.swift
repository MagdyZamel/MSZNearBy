//
//  VenuePhotoEntity+CoreDataClass.swift
//  MSZNearBy
//
//  Created by MSZ on 12/8/19.
//  Copyright © 2019 MSZ. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VenuePhotoEntity)
public class VenuePhotoEntity: NSManagedObject {

    init(venuePhoto: APIPhotoItemModel?) {
        super.init(entity: VenuePhotoEntity.entity(), insertInto: nil)
        self.height = NSDecimalNumber(value: venuePhoto?.height ?? 0)
        self.width = NSDecimalNumber(value: venuePhoto?.width ?? 0)
        self.photoId = venuePhoto?.photoId ?? ""
        self.prefix = venuePhoto?.prefix ?? ""
        self.suffix = venuePhoto?.suffix ?? ""
    }
    init(emptyPhotosWithVenueId venueId: String) {
        super.init(entity: VenuePhotoEntity.entity(), insertInto: nil)

    }

}
