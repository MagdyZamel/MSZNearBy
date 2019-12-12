//
//  UserMode.swift
//  MSZNearBy
//
//  Created by MSZ on 12/12/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

enum UserMode: Int {
    case single = 0
    case realtime = 1

    static func getCurrentMode() -> UserMode {
        let rowvalue = UserDefaults.standard.integer(forKey: "UserMode")
        return UserMode(rawValue: rowvalue) ?? .realtime
    }
    static func changeCurrentMode(mode: UserMode) {
        UserDefaults.standard.set(mode.rawValue, forKey: "UserMode")
    }
}
