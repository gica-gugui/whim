//
//  PermissionsCoordinator.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import Foundation
import CoreLocation

final class PermissionsCoordinator: BaseCoordinator, PermissionsCoordinatorOutput {
    typealias HandlerFactory =
        PrePermissionHandlerFactoryProtocol &
        LocationHandlerFactoryProtocol
    
    var finishFlow: (() -> Void)?
    
    private let handlerFactory: HandlerFactory
    private let router: RouterProtocol
    
    init(handlerFactory: HandlerFactory, router: RouterProtocol) {
        self.handlerFactory = handlerFactory
        self.router = router
    }
    
    override func start() {
        handleLocationPermissionStatus()
    }
    
    //MARK: - Run current flow's handlers
    
    private func handleLocationPermissionStatus() {
        let handler = handlerFactory.getLocationHandler()
        
        handler.onPermissionStatusObtained = { [weak self, weak handler] permissionStatus in
            if permissionStatus == CLAuthorizationStatus.notDetermined {
                self?.handleLocationPrePermission()
            } else {
                self?.finishFlow?()
            }
            
            self?.removeDependency(handler)
        }
        
        addDependency(handler)
        
        let locationOption = LocationHandlerOption.build(type: LocationConstants.PermissionStatus)
        handler.handle(with: locationOption)
    }
    
    private func handleLocationPrePermission() {
        let handler = handlerFactory.getPrePermissionHandler()
        
        handler.onPrePermissionCreated = { [weak self] prePermissionOutput in
            self?.router.present(prePermissionOutput)
        }
        
        let title = NSLocalizedString("permissionCoordinator.locationPrePermission.title", comment: "")
        let message = NSLocalizedString("permissionCoordinator.locationPrePermission.message", comment: "")
        
        let acceptHandler: (() -> ()) = { [weak self, weak handler] in
            self?.handleLocationPermission()
            
            self?.removeDependency(handler)
        }
        
        let denyHandler: (() -> ()) = { [weak self, weak handler] in
            self?.finishFlow?()
            
            self?.removeDependency(handler)
        }
        
        addDependency(handler)
        
        let prePermissionOption = PrePermissionHandlerOption.build(type: PrePremissionConstants.CreatePrePermission, title: title, message: message, onAcceptButtonTap: acceptHandler, onDenyButtonTap: denyHandler)
        
        DispatchQueue.main.async {
            handler.handle(with: prePermissionOption)
        }
    }
    
    private func handleLocationPermission() {
        let handler = handlerFactory.getLocationHandler()
        
        handler.onRequestPermissionComplete = { [weak self, weak handler] () in
            self?.finishFlow?()
            
            self?.removeDependency(handler)
        }
        
        addDependency(handler)
        
        let locationOption = LocationHandlerOption.build(type: LocationConstants.RequestPermission)
        handler.handle(with: locationOption)
    }
}
