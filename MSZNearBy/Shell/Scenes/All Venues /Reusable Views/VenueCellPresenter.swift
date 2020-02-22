//
//  VenueCellPresenterProtocol.swift
//  MSZNearBy
//
//  Created by MSZ on 12/12/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
protocol VenueCellPresenterProtocol {
    var useCase: GetVenuePhotosUseCaseProtocol {get set}
    func attach(view: VenueCellViewProtocol)
    func viewDidAttach()
    func detachView()
}

class VenueCellPresenter: VenueCellPresenterProtocol {

    private weak var view: VenueCellViewProtocol?
    @Injected var useCase: GetVenuePhotosUseCaseProtocol
    private  var photo: VenuePhotoEntity!
    var venue: VenueEntity!
    var location: LocationCoordinates!

    func attach(view: VenueCellViewProtocol) {
        self.view = view
        self.viewDidAttach()
    }

    func viewDidAttach() {
        view?.display(address: venue.location )
        view?.display(name: venue.name)
        view?.displayVenueImagePlaceHolder()
        useCase.update(location: location, venueEntity: venue)
        useCase.execute(VenuePhotoEntity.self).then { [weak self] (venuePhoto)  in
            self?.photo = venuePhoto
            self?.view?.display(venueImage: venuePhoto.image)
        }.catch { (error) in
            print(message: error)
        }
    }

    func detachView() {
        view = nil
    }

}
