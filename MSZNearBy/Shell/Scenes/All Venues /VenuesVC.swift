//
//  VenuesVC.swift
//  MSZNearBy
//
//  Created by MSZ on 12/11/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import UIKit

protocol VenuesView: class {
    func reloadVenuesData()
    func showMessage(_ message: String)
    func showLoader()
    func hideLoader()
    func localizeViews()

}

class VenuesVC: UIViewController, VenuesView {

    @IBOutlet weak var venuesCollectionView: UICollectionView!
    @IBOutlet weak var singleModeButton: UIBarButtonItem!
    @IBOutlet weak var realtimeModeButton: UIBarButtonItem!
    @IBOutlet weak var indecator: UIActivityIndicatorView!

    var presenter: VenuesPresenterProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        configCollectionView()
    }
    
    func localizeViews() {
        realtimeModeButton.title =  "realtimeModeButton".localized
        singleModeButton.title =  "singleModeButton".localized
        self.title = "NearByTitle".localized
    }
    
    func reloadVenuesData() {
        venuesCollectionView.reloadData()
    }
    
    func showMessage(_ message: String) {
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok".localized,
                                         style: .default,
                                         handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    func showLoader() {
        indecator.startAnimating()
        venuesCollectionView.isHidden = true
    }
    
    func hideLoader() {
        indecator.stopAnimating()
        venuesCollectionView.isHidden = false
    }

    @IBAction func realtimeModeTapped() {
        presenter.realtimeModeTapped()
    }
    
    @IBAction func singleModeTapped() {
        presenter.singleModeTapped()
    }
}
