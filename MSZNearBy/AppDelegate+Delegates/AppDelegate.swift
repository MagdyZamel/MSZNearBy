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
    func setIntialVIew() {
        window = UIWindow()
        guard !AppConfigurator.isUnitTesting else {

        self.window?.rootViewController = UIViewController()
            self.window?.makeKeyAndVisible()
            return

        }

        let venuesVC: VenuesVC = Resolver.resolve()
        self.window?.rootViewController = venuesVC
        self.window?.makeKeyAndVisible()
    }

}
