//
//  VenueCell.swift
//  MSZNearBy
//
//  Created by MSZ on 12/11/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import UIKit

protocol VenueCellViewProtocol: class {
    func display(venueImage: Data?)
    func display(address: String)
    func display(name: String)
    func displayVenueImagePlaceHolder()
}

class VenueCell: UICollectionViewCell, VenueCellViewProtocol {
    
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    var presenter: VenueCellPresenterProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func prepareForReuse() {
        presenter.detachView()
    }
    func cellDidDequeued() {
        presenter.attach(view: self)
    }
    
    func display(venueImage: Data?) {
        guard let dataImage = venueImage,
            let image = UIImage(data: dataImage) else {
            return
        }
        UIView.transition(with: self.venueImageView,
                                  duration: 5,
                                  options: .transitionCrossDissolve,
                                  animations: { self.venueImageView.image = image },
                                  completion: nil)
    }
    func displayVenueImagePlaceHolder() {
        self.venueImageView.image = UIImage(named: "PlaceHolder")
    }
    func display(address: String) {
        addressLabel.text = address
    }
    
    func display(name: String) {
        venueNameLabel.text = name
    }
    
}
