//
//  VenueEntity+CoreDataClass.swift
//  MSZNearBy
//
//  Created by MSZ on 12/8/19.
//  Copyright © 2019 MSZ. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VenueEntity)
public class VenueEntity: NSManagedObject {

    convenience init(venue: APIVenueModel?, insertInto context: NSManagedObjectContext? = nil) {
        self.init(entity: VenueEntity.entity(), insertInto: context)
        self.lat = venue?.location?.lat ?? 0
        self.long = venue?.location?.lng ?? 0
        self.location = venue?.location?.formattedAddress?.joined(separator: ", ") ?? ""
        self.name = venue?.name ?? ""
        self.venueId = venue?.venueId ?? ""
    }
    func inject(venue: APIVenueModel?) {
        self.lat = venue?.location?.lat ?? 0
        self.long = venue?.location?.lng ?? 0
        self.location = venue?.location?.formattedAddress?.joined(separator: ", ") ?? ""
        self.name = venue?.name ?? ""
        self.venueId = venue?.venueId ?? ""

    }
}
extension VenueEntity {
    static func == (lhs: VenueEntity, rhs: VenueEntity) -> Bool {
        return lhs.venueId == rhs.venueId
    }
}
