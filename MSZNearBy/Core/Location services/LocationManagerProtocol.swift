//
//  LocationManagerProtocol.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

 protocol LocationManagerProtocol: class {
    func getCurrentLocation() -> LocationCoordinates
    func getlastLocationTimestamp() -> Date
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func checkLocationStatus(status: LocationStatus) -> Bool? 
    var delegate: LocationManagerDelegate? {get set}
    
}
 @objc protocol LocationManagerDelegate: class {
    func userAuthorizedLocation()
    func userDeniedLocation()
    @objc optional func didUpdateLocations(location: LocationCoordinates)
}

class LocationCoordinates: NSObject, Codable {
    var lat: Double
    var long: Double

    override init() {
        self.lat = 0.0
        self.long = 0.0
    }

    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }

    enum CodingKeys: String, CodingKey {
        case lat = "latitude"
        case long = "longitude"
    }
}
