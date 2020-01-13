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
        let api = Api()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30
        configuration.timeoutIntervalForRequest = 30
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        api.manager = SessionManagerHandler.sharedInstance(configuration: configuration)
        
        let wikiRepository = WikiRepository()
        wikiRepository.api = api
        
        let viewModel = MapViewModel(wikiRepository: wikiRepository)
        
        let viewController = MapViewController.controllerFromStoryboard(.main)
        
        viewController.viewModel = viewModel
        
        return viewController
    }
}
