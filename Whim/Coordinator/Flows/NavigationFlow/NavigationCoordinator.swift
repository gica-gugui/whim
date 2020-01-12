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
    typealias ModuleFactory =
        MapModuleFactoryProtocol &
        MapDetailsModuleFactoryProtocol
    
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: RouterProtocol
    private let factory: ModuleFactory
    private let handlerFactory: HandlerFactory
    
    var finishFlow: (() -> Void)?
    
    private weak var mapView: MapViewProtocol!
    private weak var mapDetailsView: MapDetailsViewProtocol!
    
    init(factory: ModuleFactory,
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
 
        mapView.onPOIDetailsTap = { [weak self] mapAnnotation in
            self?.showPoiDetails(annotation: mapAnnotation)
        }
        
        router.setRootModule(mapView, hideBar: true)
    }
    
    private func showPoiDetails(annotation: MapAnnotation) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15 , execute: { [weak self] in
            self?.mapDetailsView = self?.factory.makeMapDetailsOutput()
            
            self?.mapDetailsView.snapshotImage = self?.router.snapshot()
            
            self?.router.presentWithSnapshot(self?.mapDetailsView)
        })
        
        //TODO
        // relese objects from memory
    }
    
    private func runPermissionsFlow() {
        let coordinator = coordinatorFactory.makePermissionsCoordinator(router: router)
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.handleLocationObtained()
            
            self?.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func handleLocationObtained() {
        let handler = handlerFactory.getLocationHandler()
        
        handler.onDidUpdateLocations = { [weak self, weak handler] (locations: [CLLocation]) in
            if locations.count == 1 {
                self?.mapView.locationObtained(location: locations[0])
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
