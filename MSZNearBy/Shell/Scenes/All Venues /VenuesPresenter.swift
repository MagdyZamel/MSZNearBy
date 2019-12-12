//
//  VenuesPresenter.swift
//  MSZNearBy
//
//  Created by MSZ on 12/12/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

enum VenuesReusable {
    case venueCell
}
protocol VenuesPresenterProtocol: class {
    func realtimeModeTapped()
    func singleModeTapped()
    func attach(view: VenuesView)
    func viewDidAttach()
    func reusubelCellType(at indexpath: IndexPath) -> VenuesReusable
    func cellPreseneter(at indexpath: IndexPath) -> VenueCellPresenterProtocol
    func numberOfItems(inSection section: Int) -> Int 
    
}

class VenuesPresenter: VenuesPresenterProtocol {
    
    var cellsPresenters = [IndexPath: VenueCellPresenterProtocol]()
    weak var view: VenuesView!
    var useCase: GetVenuesUseCaseProtocol
    var lastOffset = 0
    var limit = 50
    
    init(useCase: GetVenuesUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func attach(view: VenuesView) {
        self.view = view
        viewDidAttach()
    }
    
    func viewDidAttach() {
        view.localizeViews()
        view.showLoader()
        useCase.delegate = self
        useCase.update(offset: lastOffset, limit: limit)
        
        useCase.execute([VenueEntity].self).then { venues in
            self.modifyCellsPresenters(venues: venues,
                                       atLocation: self.useCase.location ?? LocationCoordinates())
            
        }.catch { [weak view](error) in
            view?.showMessage(error.message)
        }.always { [weak view] in
            view?.hideLoader()
        }
        
    }
    
    func reusubelCellType(at indexpath: IndexPath) -> VenuesReusable {
        return .venueCell
    }
    
    func cellPreseneter(at indexpath: IndexPath) -> VenueCellPresenterProtocol {
        if let presenter  = self.cellsPresenters[indexpath] {
            return presenter
        }
        fatalError("Invaled indexpath")
    }
    func realtimeModeTapped() {
        guard UserMode.getCurrentMode() != .realtime else {
            return
        }
        UserMode.changeCurrentMode(mode: .realtime)
        useCase.update(userMode: .realtime)
    }
    
    func singleModeTapped() {
        guard UserMode.getCurrentMode() != .single else {
            return
        }
        UserMode.changeCurrentMode(mode: .single)
        useCase.update(userMode: .single)
    }

    func modifyCellsPresenters( venues: [VenueEntity], atLocation location: LocationCoordinates) {
        for (index, venue) in venues.enumerated() {
            let indexpath = IndexPath(item: index, section: 0)
            let venuePhotosRepo  = Singletons.repositoriesManger.venuePhotosRepo
            let usecase = GetVenuePhotosUseCase(venuePhotosRepo: venuePhotosRepo )
            let presenter = VenueCellPresenter(useCase: usecase)
            presenter.location = location
            presenter.venue = venue
            cellsPresenters[indexpath] = presenter
        }
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return cellsPresenters.count
    }
}

extension VenuesPresenter: GetVenuesUseCaseDelegate {
    func getVenuesUseCase(foundVenues venues: [VenueEntity], atLocation location: LocationCoordinates) {
        print(venues.count)
        cellsPresenters.removeAll()
        modifyCellsPresenters(venues: venues, atLocation: location)
          view.reloadVenuesData()
    }
}
