//
//  CoordinatorFactory.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit

final class CoordinatorFactory: CoordinatorFactoryProtocol {
    func makeNavigationCoordinator(router: RouterProtocol) -> CoordinatorDelegate & NavigationCoordinatorOutput {
        return NavigationCoordinator(factory: ModuleFactory(), coordinatorFactory: CoordinatorFactory(), handlerFactory: HandlerFactory(), router: router)
    }
    
    func makePermissionsCoordinator(router: RouterProtocol) -> CoordinatorDelegate & PermissionsCoordinatorOutput {
        let coordinator = PermissionsCoordinator(
            handlerFactory: HandlerFactory(),
            router: router
        )
        
        return coordinator
    }
}
