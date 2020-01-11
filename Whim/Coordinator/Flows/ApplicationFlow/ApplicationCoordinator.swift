//
//  ApplicationCoordinator.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import CoreLocation
import UserNotifications

final class ApplicationCoordinator: BaseCoordinator {
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let handlerFactory: HandlerFactoryProtocol
    private let router: RouterProtocol
    
    init(router: RouterProtocol,
         coordinatorFactory: CoordinatorFactoryProtocol,
         handlerFactory: HandlerFactoryProtocol) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.handlerFactory = handlerFactory
    }
    
    override func start() {
        runMainFlow()
    }
    
    private func runMainFlow() {
        let coordinator = coordinatorFactory.makeNavigationCoordinator(router: router)
        
        // TODO this is not necessary - we never finish main flow as we don't have auth
//        coordinator.finishFlow = { [weak self, weak coordinator] in
//            self?.router.popToRootModule(animated: false)
//
//            self?.start()
//            self?.removeDependency(coordinator)
//        }
        
        addDependency(coordinator)
        coordinator.start()
    }
}
