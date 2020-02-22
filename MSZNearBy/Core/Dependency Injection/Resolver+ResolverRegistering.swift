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
        setupReposNetworkDependencies()
        setupVenuesRepository()
        setupVenuePhotosRepository()
        setupUseCases()
        setupViewControllers()
        setupPresenters()

    }
}
