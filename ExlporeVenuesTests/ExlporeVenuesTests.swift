//
//  ExlporeVenuesTests.swift
//  ExlporeVenuesTests
//
//  Created by MSZ on 12/15/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import XCTest
import Promises
@testable import MSZNearBy

class ExlporeVenuesTests: XCTestCase {

    var useCase: GetVenuesUseCase!
    var venuesRepositorySpy = VenuesRepositorySpy()
    var locationManagerSpy = LocationManagerSpy()

    override func setUp() {

        useCase = GetVenuesUseCase(venuesRepo: venuesRepositorySpy, locationManager: locationManagerSpy)

    }
    var venuesCount = 0

    func test_getVenues_WithSuccessPromise() {
        // Given
        venuesRepositorySpy.isSucceed = true

        // When
        locationManagerSpy.neededLocation = .init(lat: 70, long: 60)
        locationManagerSpy.delegate?.userAuthorizedLocation()
        // Then
        useCase.execute([VenueEntity].self).then { (venues )  in
            self.venuesCount = venues.count
        }
        let pred = NSPredicate(format: "venuesCount != 0")
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        let res = XCTWaiter.wait(for: [exp], timeout: 5.0)
        if res == XCTWaiter.Result.completed {
            XCTAssertEqual(venuesCount, 44, "Data wrong recived from the repo")
        } else {
            XCTAssert(false, "No data recived from  the repo")
        }
    }

    var userDeniedLocationErrorMessge = ""
    func test_getVenues_locationDenaied_WithFailurePromise() {
        // Given
        venuesRepositorySpy.isSucceed = true
        // When
        locationManagerSpy.delegate?.userDeniedLocation()
        // Then
        useCase.execute([VenueEntity].self).catch { (error) in
            self.userDeniedLocationErrorMessge = error.message
        }
        let pred = NSPredicate(format: "userDeniedLocationErrorMessge != %@", "")
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        let res = XCTWaiter.wait(for: [exp], timeout: 5.0)
        if res == XCTWaiter.Result.completed {
            XCTAssertNotEqual(userDeniedLocationErrorMessge, "", "location permision denied but it dosent reflect")
        } else {
            XCTAssert(false, "No data recived from  the repo")
        }
    }

}
