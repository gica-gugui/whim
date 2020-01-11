//
//  NavigationCoordinat.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import Foundation
import CoreLocation

class NavigationCoordinator: BaseCoordinator, NavigationCoordinatorOutput {
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: RouterProtocol
    private let factory: MapModuleFactoryProtocol
    private let handlerFactory: HandlerFactory
    
    var finishFlow: (() -> Void)?
    
    private weak var mapView: MapViewProtocol!
    
    init(factory: MapModuleFactoryProtocol,
         coordinatorFactory: CoordinatorFactoryProtocol,
         handlerFactory: HandlerFactory,
         router: RouterProtocol) {
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
        self.handlerFactory = handlerFactory
        self.router = router
    }
    
    override func start() {
        showMap()
        runPermissionsFlow()
    }
    
    private func showMap() {
        mapView = factory.makeMapOutput()
 
        router.setRootModule(mapView, hideBar: true)
    }
    
    private func runPermissionsFlow() {
        let coordinator = coordinatorFactory.makePermissionsCoordinator(router: router)
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.handleStartLocation()
            
            self?.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func handleStartLocation() {
        let handler = handlerFactory.getLocationHandler()
        
        handler.onDidUpdateLocations = { [weak self, weak handler] (locations: [CLLocation]) in
            if locations.count == 1 {
                self?.mapView.loadPointOfInterests(location: locations[0])
            }
            
            self?.removeDependency(handler)
        }
        
        addDependency(handler)
        
        let handlerOption = LocationHandlerOption.build(type: LocationConstants.RetrieveLocation)
        handler.handle(with: handlerOption)
    }
    
    private func removeAllDependencies() {
        for (_, element) in childCoordinators.enumerated() {
            removeDependency(element)
        }
    }
}
