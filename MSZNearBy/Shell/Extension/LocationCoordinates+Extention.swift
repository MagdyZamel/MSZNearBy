//
//  LocationCoordinates+Extention.swift
//  MSZNearBy
//
//  Created by MSZ on 12/11/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import CoreLocation
extension LocationCoordinates {
    func distance(from location: LocationCoordinates) -> Double {
        let firsLocation = CLLocation(latitude: self.lat, longitude: self.long)
        let secondLocation = CLLocation(latitude: location.lat, longitude: location.long)
        return firsLocation.distance(from: secondLocation)
    }
}
