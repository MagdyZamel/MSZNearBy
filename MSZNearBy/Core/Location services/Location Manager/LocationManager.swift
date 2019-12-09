//
//  LocationManager.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, LocationManagerProtocol {
  
    private let locationManager = CLLocationManager()
    var location = CLLocationCoordinate2D()

    weak var delegate: LocationManagerDelegate? {
        didSet {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.allowsBackgroundLocationUpdates = true
            if CLLocationManager.locationServicesEnabled() {
                start()
            }
        }
    }

    var currentLocation: LocationCoordinates {
        return LocationCoordinates(lat: location.latitude, long: location.longitude)
    }

    func start() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func checkStatus() {
        checkStatus(status: CLLocationManager.authorizationStatus())
    }
    func checkStatus(status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()) {
        if let locationStatus = checkLocationStatus(status: LocationStatus(status: status) ) {
            updateStatus(status: locationStatus)
        }
    }
    func updateStatus(status: Bool) {
        if status {
            delegate?.userAuthorizedLocation()
        } else {
            delegate?.userDeniedLocation()
        }
    }

    func checkLocationStatus(status: LocationStatus) -> Bool? {
        switch status {
        case .notDetermined:
            return nil
        case .authorized:
            return true
        case .denied:
            return false
        }
    }


    func didChangeAuthorization(status: LocationStatus) {

        if let locationStatus = checkLocationStatus(status: status) {
            if locationStatus {
                start()
                delegate?.userAuthorizedLocation()
            } else {
                delegate?.userDeniedLocation()
            }
        }
    }

    func didUpdateLocations(lat: Double, long: Double) {
        self.location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let locationCoordinates = LocationCoordinates(lat: lat, long: long)
        delegate?.didUpdateLocations?(location: locationCoordinates)
        print("locations = \(location.latitude) \(location.longitude)")
    }
}
