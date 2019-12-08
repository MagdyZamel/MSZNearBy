//
//  VenueEntity+CoreDataProperties.swift
//  MSZNearBy
//
//  Created by MSZ on 12/8/19.
//  Copyright © 2019 MSZ. All rights reserved.
//
//

import Foundation
import CoreData


extension VenueEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VenueEntity> {
        return NSFetchRequest<VenueEntity>(entityName: "Venue")
    }

    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var venueId: String?
    @NSManaged public var long: Double
    @NSManaged public var lat: Double
    @NSManaged public var venue: VenueEntity?

}
