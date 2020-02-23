//
//  Resolver+ResolverRegistering.swift
//  Al-Ahly Academy
//
//  Created by MSZ on 2/18/20.
//  Copyright © 2020 MSZ. All rights reserved.
//

import Foundation
@testable import MSZNearBy
extension Resolver: ResolverRegistering {
    public static func registerAllServices() {

        mock.register { LocationManagerSpy()}.implements(LocationManagerProtocol.self)
            .scope(Resolver.application )
        mock.register { VenuesRepositorySpy()}.implements(VenuesRepositoryProtocal.self)
            .scope(Resolver.application )
        mock.register { GetVenuesUseCase(venuesRepo: resolve(), locationManager: resolve()) as GetVenuesUseCaseProtocol}
    }
}
