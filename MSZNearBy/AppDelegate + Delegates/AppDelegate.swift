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
        return true
    }

}
