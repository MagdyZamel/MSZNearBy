//
//  AppConfigurator.swift
//  MSZNearBy
//
//  Created by MSZ on 12/5/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import UIKit
import Promises

#if DEBUG
    import CocoaDebug
#endif
class AppConfigurator: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        #if DEBUG
        CocoaDebug.enable()
        #endif
        return true
    }
}
func print<T>(file: String = #file,
              function: String = #function,
              line: Int = #line,
              _ message: T, color: UIColor = .white) {
    #if DEBUG
        swiftLog(file, function, line, message, color, false)
    #endif
}
