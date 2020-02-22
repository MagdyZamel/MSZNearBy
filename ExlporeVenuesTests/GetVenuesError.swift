//
//  GetVenuesError.swift
//  ExlporeVenuesTests
//
//  Created by MSZ on 12/15/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

enum GetVenuesError: Error {
    case noVenues
    case locationPermessionNeeded
    case gpsNotWorking

}
