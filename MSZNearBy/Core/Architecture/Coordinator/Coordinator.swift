//
//  Coordinator.swift
//  MSZNearBy
//
//  Created by MSZ on 12/9/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    func start()
}

extension Coordinator {
    func start() {
        print("start PresenterCoordinator ")
    }
}

class PresenterCoordinator: Coordinator {

    weak  var viewController: UIViewController?
    weak var navigationController: UINavigationController?

    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}
class NavigationCoordinator: Coordinator {

    weak var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}
