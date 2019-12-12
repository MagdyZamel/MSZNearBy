//
//  CustomFLowLayout.swift
//  MSZNearBy
//
//  Created by MSZ on 12/12/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import UIKit

class CustomFLowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        guard let collectionView  = collectionView else { return }
        self.minimumLineSpacing = 8
        self.minimumInteritemSpacing = 1
        self.sectionInset = UIEdgeInsets.init(top: self.minimumLineSpacing, left: 10, bottom: 0, right: 10)
        if #available(iOS 11.0, *) {
            self.sectionInsetReference = .fromContentInset
        }
        var availableWidth = collectionView.bounds.inset(by: sectionInset).size.width
        let minCellWidth = CGFloat(250
    )
        let maxColumn  =  Int(availableWidth/minCellWidth)
        availableWidth -= CGFloat(maxColumn)*minimumLineSpacing
        let itemWidth = (availableWidth/CGFloat(maxColumn)).rounded(.down)
        self.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
    }
    
}
