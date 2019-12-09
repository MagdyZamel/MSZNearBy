//
//  LocationManger+CLLocationManagerDelegate.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import CoreLocation
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        let status = LocationStatus(status: status)
        didChangeAuthorization(status: status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        didUpdateLocation(manager.location)
    }

    func didUpdateLocation(_ location: CLLocation?) {
        guard let locValue: CLLocationCoordinate2D = location?.coordinate else { return }
        didUpdateLocations(lat: locValue.latitude, long: locValue.longitude)
    }
}
