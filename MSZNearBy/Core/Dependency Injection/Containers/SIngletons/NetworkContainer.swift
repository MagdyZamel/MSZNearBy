//
//  Network.swift
//  Al-Ahly Academy
//
//  Created by MSZ on 2/19/20.
//  Copyright © 2020 MSZ. All rights reserved.
//

import Foundation
extension Resolver {
    static func setupReposNetworkDependencies() {
        register { APIManager() as NetworkManagerProtocol }
            .scope(Resolver.application)
        register { InternetConnectionManager() as InternetManagerProtocol }
            .scope(Resolver.application)
        register { APIRequestProvider(internetManager: resolve()) as APIRequestProviderProtocol }
            .scope(Resolver.application)
        register { LocationManager() as LocationManagerProtocol }
            .scope(Resolver.application)
        register { CoreDataStackManager(containerName: "NearBYModel") as DataBaseManagerProtocol }
            .scope(Resolver.application)

    }
}
