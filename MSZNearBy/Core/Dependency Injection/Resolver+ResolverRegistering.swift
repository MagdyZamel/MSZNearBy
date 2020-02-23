//
//  Resolver+ResolverRegistering.swift
//  Al-Ahly Academy
//
//  Created by MSZ on 2/18/20.
//  Copyright © 2020 MSZ. All rights reserved.
//

import Foundation

extension Resolver: ResolverRegistering {

    public static func registerAllServices() {
        if !AppConfigurator.isUnitTesting {
            setupReposNetworkDependencies()
            setupVenuesRepository()
            setupVenuePhotosRepository()
            setupUseCases()
            setupViewControllers()
            setupPresenters()
        }

    }
}
