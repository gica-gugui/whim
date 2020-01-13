//
//  NavigationCoordinat.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class NavigationCoordinator: BaseCoordinator, NavigationCoordinatorOutput {
    typealias ModuleFactory =
        MapModuleFactoryProtocol & NoInternetModuleFactoryProtocol
    
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: RouterProtocol
    private let factory: ModuleFactory
    private let handlerFactory: HandlerFactory
    
    var finishFlow: (() -> Void)?
    
    private weak var mapView: MapViewProtocol!
    
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
        handleConnectivity()
    }
    
    private func showMap() {
        mapView = factory.makeMapOutput()
 
        mapView.openWikipediaArticle = { urlString in
            guard let url = URL.init(string: urlString) else {
                return
            }
            
            UIApplication.shared.open(url)
        }
        
        router.setRootModule(mapView, hideBar: true)
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
    
    private func handleConnectivity() {
        let handler = handlerFactory.getReachabilityHandler()
        
        handler.onListenerNotified = { [weak self] status in
            switch status {
            case .notReachable, .unknown:
                let noInternetView = self?.factory.makeNoInternetOutput()
                self?.router.present(noInternetView)
            case .reachable(_):
                self?.router.dismissModule(animated: true, completion: nil)
            }
        }
        
        addDependency(handler)
        
        let handlerOption = ReachabilityHandlerOption.build(type: ReachabilityConstants.StartListening)
        handler.handle(with: handlerOption)
    }
    
    private func removeAllDependencies() {
        for (_, element) in childCoordinators.enumerated() {
            removeDependency(element)
        }
        
        for (_, element) in handlers.enumerated() {
            removeDependency(element)
        }
    }
}
