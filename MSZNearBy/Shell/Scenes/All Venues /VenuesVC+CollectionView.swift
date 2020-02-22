//
//  VenuesVC+CollectionView.swift
//  MSZNearBy
//
//  Created by MSZ on 12/12/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import UIKit

extension VenuesVC {
    func configCollectionView() {
        let nib = UINib(nibName: VenueCell.className, bundle: nil)
        venuesCollectionView.register(nib, forCellWithReuseIdentifier: VenueCell.className )
        venuesCollectionView.collectionViewLayout = CustomFLowLayout()
        venuesCollectionView.dataSource = self
    }
}
extension VenuesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems(inSection: section)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch presenter.reusubelCellType(at: indexPath) {
        case .venueCell:
            guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: VenueCell.className,
                                                                 for: indexPath) as? VenueCell else {
                fatalError("Reuseing  non registerd Identifier ")
            }
            cell.presenter = presenter.cellPreseneter(at: indexPath)
            cell.cellDidDequeued()
            return cell
        }
    }
}
