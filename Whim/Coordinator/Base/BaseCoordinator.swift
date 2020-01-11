//
//  BaseCoordinator.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

class BaseCoordinator: CoordinatorDelegate {
    var childCoordinators: [CoordinatorDelegate] = []
    var handlers: [HandlerProtocol] = []
    
    func start() { }
    
    // add only unique object
    func addDependency(_ coordinator: CoordinatorDelegate) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        
        childCoordinators.append(coordinator)
    }
    
    func removeAllDependenciesOf(type coordinatorInstance: CoordinatorDelegate?) {
        guard childCoordinators.isEmpty == false, let coordinatorInstance = coordinatorInstance else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if type(of: element) == type(of: coordinatorInstance) {
                childCoordinators.remove(at: index)
            }
        }
    }
    
    func removeAllDependenciesOf(type coordinator: AnyClass?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if type(of: element) == coordinator {
                childCoordinators.remove(at: index)
            }
        }
    }
    
    func removeDependency(_ coordinator: CoordinatorDelegate?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func addDependency(_ handler: HandlerProtocol) {
        handlers.append(handler)
    }
    
    func removeDependency(_ handler: HandlerProtocol?) {
        guard
            handlers.isEmpty == false,
            let handler = handler
            else { return }
        
        for (index, element) in handlers.enumerated() {
            if element === handler {
                handlers.remove(at: index)
                break
            }
        }
    }
}
