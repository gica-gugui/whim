//
//  ModuleFactory.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit

typealias ModuleFactoryProtocol = MapModuleFactoryProtocol

final class ModuleFactory: ModuleFactoryProtocol {
    func makeMapOutput() -> MapViewProtocol {
        let viewModel = MapViewModel.init()
        let viewController = MapViewController.controllerFromStoryboard(.main)
        
        viewController.viewModel = viewModel
        
        return viewController
    }
}
