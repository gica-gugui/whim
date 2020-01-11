//
//  CoordinatorFactoryProtocol.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    func makeNavigationCoordinator(router: RouterProtocol) -> CoordinatorDelegate & NavigationCoordinatorOutput
    
    func makePermissionsCoordinator(router: RouterProtocol) -> CoordinatorDelegate & PermissionsCoordinatorOutput
}
