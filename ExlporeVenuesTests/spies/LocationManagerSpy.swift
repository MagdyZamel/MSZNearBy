//
//  LocationManagerSpy.swift
//  ExlporeVenuesTests
//
//  Created by MSZ on 12/15/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
@testable import MSZNearBy

class LocationManagerSpy: LocationManagerProtocol {
    
    var neededLocation: LocationCoordinates?
    func checkLocationStatus(status: LocationStatus) -> Bool? {
        return true
    }
    
    func getCurrentLocation() -> LocationCoordinates {
        return  neededLocation ?? .init(lat: 0, long: 0 )
    }
    
    func getlastLocationTimestamp() -> Date {
        return Date()
    }
    
    func startUpdatingLocation() {
        
    }
    
    func stopUpdatingLocation() {
        
    }
    
    weak var delegate: LocationManagerDelegate?
    
}
