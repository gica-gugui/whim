//
//  AppDelegate.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var rootController: BaseNavigationController {
        return self.window!.rootViewController as! BaseNavigationController
    }
    
    private lazy var applicationCoordinator: CoordinatorDelegate = self.makeCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        applicationCoordinator.start()
        
        return true
    }

    fileprivate func makeCoordinator() -> CoordinatorDelegate {
        return ApplicationCoordinator(
            router: Router(rootController: self.rootController),
            coordinatorFactory: CoordinatorFactory(),
            handlerFactory: HandlerFactory()
        )
    }
}

