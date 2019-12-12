//
//  VenueCellPresenterProtocol.swift
//  MSZNearBy
//
//  Created by MSZ on 12/12/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
protocol VenueCellPresenterProtocol {
    func attach(view: VenueCellViewProtocol)
    func viewDidAttach()
    func detachView()
}

class VenueCellPresenter: VenueCellPresenterProtocol {
    
    weak var view: VenueCellViewProtocol?
    var useCase: GetVenuePhotosUseCaseProtocol
   
    var photo: VenuePhotoEntity!
    var venue: VenueEntity!
    var location: LocationCoordinates!
    
    init(useCase: GetVenuePhotosUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func attach(view: VenueCellViewProtocol) {
        self.view = view
        self.viewDidAttach()
    }
    
    func viewDidAttach() {
        view?.display(address: venue.location )
        view?.display(name: venue.name)
        useCase.location = location
        useCase.venueEntity = venue
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
