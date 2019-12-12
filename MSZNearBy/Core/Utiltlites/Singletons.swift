//
//  Singletons.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

enum Singletons {
    static let internetManager = InternetConnectionManager()
    static let apiRequestProvider = APIRequestProvider(internetManager: internetManager)
    static let apiManager = APIManager()
    static let coreDataStackManager = CoreDataStackManager(containerName: "NearBYModel")
    static let repositoriesManger = RepositoriesManger()
    static let locationManager = LocationManager()
    
}
