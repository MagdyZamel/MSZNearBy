//
//  GetVenuesUseCase.swift
//  MSZNearBy
//
//  Created by MSZ on 12/12/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

protocol GetVenuesUseCaseProtocol: BaseUseCaseProtocol {
    func update( offset: Int, limit: Int)
    func update( userMode: UserMode)
    var delegate: GetVenuesUseCaseDelegate? {get set }
    var location: LocationCoordinates? {get set }
}

protocol GetVenuesUseCaseDelegate: class {
    func getVenuesUseCase( foundVenues venues: [VenueEntity], atLocation location: LocationCoordinates)
}

class GetVenuesUseCase: BaseUseCase, GetVenuesUseCaseProtocol {
    
    private let defaultLimit = 0
    
    private var radius: Int
    private var offset: Int
    private var limit: Int
    
    var location: LocationCoordinates?
    private var isLocationPermissionAuthorized: Bool = false
    private var lastLocationTimestamp: Date?
    
    private let venuesRepo: VenuesRepositoryProtocal
    private let locationManager: LocationManagerProtocol
    
    private var userMode = UserMode.getCurrentMode()
    
    weak var delegate: GetVenuesUseCaseDelegate?
    var lastNumberOfVenues = 0
    init(venuesRepo: VenuesRepositoryProtocal,
         locationManager: LocationManagerProtocol) {
        self.venuesRepo = venuesRepo
        offset = 0
        radius = Int(Constants.userRadius)
        limit = defaultLimit
        self.locationManager = locationManager
        super.init()
        locationManager.delegate = self
    }
    func update( offset: Int, limit: Int) {
        self.offset = offset
        self.limit = limit
    }
    func update( userMode: UserMode) {
        self.userMode = userMode
        if userMode == .realtime {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    override func extract() {
        location = locationManager.getCurrentLocation()
        
    }
    override func validate() throws {
        if  !isLocationPermissionAuthorized {
            throw NSError.init(domain: "Turn Location Services and GPS",
                               code: 1012, userInfo: nil)
        }
        
    }
    override func process<T>(_ outputType: T.Type) -> Promise<T> {
        
        let resultPromise = Promise<T>.pending()
        let (radius, offset, limit) = (self.radius, self.offset, self.limit)
        return retry(on: .main, attempts: 4, delay: 2, condition: { (_, error) -> Bool in
            return (error as NSError).code  == 10
        }, { [weak self]()  in
            guard let location = self?.location else {
                return Promise<T>.init(NSError.init(domain: "", code: 10, userInfo: nil))
            }
            self?.venuesRepo.getVenues(location: location,
                                       radius: radius,
                                       offset: offset,
                                       limit: limit).then { (venues) in
                                        self?.lastNumberOfVenues = venues.count
                                        if let venues = venues as? T {
                                            resultPromise.fulfill(venues)
                                        } else {
                                            fatalError("")
                                        }
            }.catch(resultPromise.reject(_:))
            
            return resultPromise
        })
    }
}
extension GetVenuesUseCase: LocationManagerDelegate {
    func userAuthorizedLocation() {
        self.isLocationPermissionAuthorized = true
    }
    
    func userDeniedLocation() {
        self.isLocationPermissionAuthorized = false
        
    }
    func didUpdateLocations(location: LocationCoordinates) {
        if (self.location!.distance(from: location) > Constants.userRadius/2 && userMode == .realtime) ||
            lastNumberOfVenues == 0 {
            self.location = location
            self.execute([VenueEntity].self).then { [weak delegate] (venueEntity) in
                delegate?.getVenuesUseCase(foundVenues: venueEntity, atLocation: location)
            }
        }
        
    }
    
}
