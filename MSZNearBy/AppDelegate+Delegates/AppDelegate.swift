//
//  AppDelegate.swift
//  MSZNearBy
//
//  Created by MSZ on 12/5/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appDelegates: [UIApplicationDelegate]  = [AppConfigurator()]
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        for delegate in appDelegates {
            _ = delegate.application?(application, didFinishLaunchingWithOptions: launchOptions)
        }
        setIntialVIew()
        return true
    }
    func setIntialVIew(){
        window = UIWindow()
        let venuerepo = Singletons.repositoriesManger.venuesRepo
        let locationManager = Singletons.locationManager
        let usecase = GetVenuesUseCase(venuesRepo: venuerepo, locationManager: locationManager)
        let presenter = VenuesPresenter(useCase: usecase)
        let venuesVC = VenuesVC()
        venuesVC.presenter = presenter
        self.window?.rootViewController = venuesVC
        self.window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

    }

}
