//
//  VenuesPresenter.swift
//  MSZNearBy
//
//  Created by MSZ on 12/12/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises
enum VenuesReusable {
    case venueCell
}
protocol VenuesPresenterProtocol: class {
    var useCase: GetVenuesUseCaseProtocol {get set}

    func realtimeModeTapped()
    func singleModeTapped()
    func attach(view: VenuesView)
    func viewDidAttach()
    func reusubelCellType(at indexpath: IndexPath) -> VenuesReusable
    func cellPreseneter(at indexpath: IndexPath) -> VenueCellPresenterProtocol
    func numberOfItems(inSection section: Int) -> Int
    func tryAgainTapped()

}

class VenuesPresenter: VenuesPresenterProtocol {

    var cellsPresenters = [IndexPath: VenueCellPresenterProtocol]()
    weak var view: VenuesView!
    @Injected var useCase: GetVenuesUseCaseProtocol
    var lastOffset = 0
    var limit = 50

    func attach(view: VenuesView) {
        self.view = view
        viewDidAttach()
    }

    func viewDidAttach() {
        view.localizeViews()
        view.showLoader()
        useCase.delegate = self
        useCase.update(offset: lastOffset, limit: limit)
        retry(on: .main, attempts: 3, delay: 3, condition: { (_, error) -> Bool in
            let locationError = error as NSError
            return locationError.code == 1012
        }, { () -> Promise<[VenueEntity]> in
            return self.useCase.execute([VenueEntity].self)
        }).then { [weak self] venues in
            self?.modifyCellsPresenters(venues: venues,
                                        atLocation: self?.useCase.location ?? LocationCoordinates())
            self?.view?.hideLoader()
        }.catch { [weak view] (error) in
            view?.showMessage(error.message)
            view?.showTryAgainView(errorMessage: error.message)
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
            let args: [Any] = [location, venue]
            print(args)
            let presenter: VenueCellPresenterProtocol = Resolver.resolve(args: [location, venue])
            cellsPresenters[indexpath] = presenter
        }
    }

    func numberOfItems(inSection section: Int) -> Int {
        return cellsPresenters.count
    }

    func tryAgainTapped() {
        view.showLoader()
        view.hideTryAgainView()
        useCase.update(offset: lastOffset, limit: limit)
        retry(on: .main, attempts: 3, delay: 3, condition: { (_, error) -> Bool in
            let locationError = error as NSError
            return locationError.code == 1012
        }, { () -> Promise<[VenueEntity]> in
            return self.useCase.execute([VenueEntity].self)
        }).then { [weak self] venues in
            self?.modifyCellsPresenters(venues: venues,
                                        atLocation: self?.useCase.location ?? LocationCoordinates())
            self?.view?.hideLoader()
        }.catch { [weak view] (error) in
            view?.showMessage(error.message)
            view?.showTryAgainView(errorMessage: error.message)
        }.always { [weak view] in
            view?.hideLoader()
        }

    }

}

extension VenuesPresenter: GetVenuesUseCaseDelegate {
    func getVenuesUseCase(foundVenues venues: [VenueEntity], atLocation location: LocationCoordinates) {
        print(venues.count)
        view.hideTryAgainView()
        cellsPresenters.removeAll()
        modifyCellsPresenters(venues: venues, atLocation: location)
        view.reloadVenuesData()
    }
}
