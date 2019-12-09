//
//  LocationStatus.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationStatus {
    case notDetermined
    case authorized
    case denied

    init(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self = . notDetermined
        case .authorizedAlways, .authorizedWhenInUse:
            self = .authorized
        case .denied, .restricted:
            self = .denied
        default:
            self = .notDetermined
        }
    }
}
