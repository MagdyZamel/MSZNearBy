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
    func hideTryAgainView()
    func showTryAgainView(errorMessage: String)

}

class VenuesVC: UIViewController, VenuesView {
    
    @IBOutlet weak var venuesCollectionView: UICollectionView!
    @IBOutlet weak var singleModeButton: UIButton!
    @IBOutlet weak var realtimeModeButton: UIButton!
    @IBOutlet weak var indecator: UIActivityIndicatorView!
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var retryView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    var presenter: VenuesPresenterProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        configCollectionView()
        
    }
    
    func localizeViews() {
        realtimeModeButton.setTitle("realtimeModeButton".localized, for: .normal)
        singleModeButton.setTitle("singleModeButton".localized, for: .normal)
        titlelabel.text = "NearByTitle".localized
        errorLabel.text = "NearByTitle".localized
        if UserMode.getCurrentMode() == .realtime {
            realtimeModeTapped()
        } else {
            singleModeTapped()
        }
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
    func hideTryAgainView() {
        retryView.isHidden = true
    }
    func showTryAgainView( errorMessage: String) {
        errorLabel.text = errorMessage
        retryView.isHidden = false
    }

    @IBAction func realtimeModeTapped() {
        presenter.realtimeModeTapped()
        realtimeModeButton.backgroundColor = .green
        singleModeButton.backgroundColor = .none

    }
    
    @IBAction func tryAgainTapped(_ sender: Any) {
        presenter.tryAgainTapped()
    }
    
    @IBAction func singleModeTapped() {
        realtimeModeButton.backgroundColor = .none
        singleModeButton.backgroundColor = .green
        presenter.singleModeTapped()
    }
}
