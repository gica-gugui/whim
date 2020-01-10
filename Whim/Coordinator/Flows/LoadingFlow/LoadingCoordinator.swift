//
//  LoadingViewProtocol.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

final class LoadingCoordinator: BaseCoordinator, LoadingCoordinatorOutput {
    var finishFlow: ((Bool) -> ())?
    
    private let factory: LoadingModuleFactoryProtocol
    private let router: RouterProtocol
    private let handlerFactory: HandlerFactoryProtocol
    
    init(router: RouterProtocol,
        factory: LoadingModuleFactoryProtocol,
        handlerFactory: HandlerFactoryProtocol) {
        self.factory = factory
        self.router = router
        self.handlerFactory = handlerFactory
    }
    
    override func start() {
        showLoading()
    }
    
    //MARK: - Run current flow's controllers
    
    private func showLoading() {
        let loadingOutput = factory.makeLoadingOutput()
        
        loadingOutput.onCompleteLoad = { [weak self] isAuthorized in
            self?.finishFlow?(isAuthorized)
        }
        
        router.setRootModule(loadingOutput)
    }
}
