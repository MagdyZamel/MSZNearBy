//
//  GetVenuePhotosUseCase.swift
//  MSZNearBy
//
//  Created by MSZ on 12/12/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises
import Kingfisher

protocol GetVenuePhotosUseCaseProtocol: BaseUseCaseProtocol {
    func update(location: LocationCoordinates, venueEntity: VenueEntity)
}

class GetVenuePhotosUseCase: BaseUseCase, GetVenuePhotosUseCaseProtocol {
    
    private var venueEntity: VenueEntity!
    private var location: LocationCoordinates!
    private var photo: VenuePhotoEntity?
    private let venuePhotosRepo: VenuePhotoRepositoryProtocal
     
     init(venuePhotosRepo: VenuePhotoRepositoryProtocal) {
         self.venuePhotosRepo = venuePhotosRepo
     }
    func update(location: LocationCoordinates, venueEntity: VenueEntity) {
        self.location = location
        self.venueEntity = venueEntity
    }

    override func process<T>(_ outputType: T.Type) -> Promise<T> {
        
        if let photo = self.photo as? T, nil == self.photo?.image {
            return .init(photo)
        }
        let resultPromise = Promise<T>.pending()
        venuePhotosRepo.getPhoto(location: location, venue: venueEntity).then { (photo)  in
            if photo.image == nil {
                let stringURL = "\(photo.suffix)\(photo.width)x\(photo.height)\(photo.prefix)"
                if let url = URL(string: stringURL) {
                    KingfisherManager.shared.retrieveImage(with: url) {[weak self] result in
                        switch result {
                        case .success(let retrieveImageResult):
                            let data = retrieveImageResult.image.pngData()
                            self?.photo?.image = data
                            if let usecase = self, let photo = usecase.photo,
                            let output = photo as? T {
                                self?.venuePhotosRepo.savePhoto(photo,
                                                                inLocation: usecase.location,
                                                                forVenue: usecase.venueEntity)
                                resultPromise.fulfill(output)
                            } else {
                                resultPromise.reject(NSError.init(domain: "", code: 121, userInfo: nil))
                            }
                        case .failure(let error):
                            resultPromise.reject(error)
                        }
                    }
                }
            }
        }.catch(resultPromise.reject(_:))
        return resultPromise
        
    }
}
