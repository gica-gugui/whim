//
//  Router.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit

final class Router: NSObject, RouterProtocol {
    private weak var rootController: BaseNavigationController?
    private var completions: [UIViewController : () -> Void]
    
    init(rootController: BaseNavigationController) {
        self.rootController = rootController
        completions = [:]
    }
        
    func toPresent() -> UIViewController? {
        return rootController
    }
    
    func present(_ module: PresentableProtocol?) {
        present(module, animated: true)
    }
    
    func present(_ module: PresentableProtocol?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func presentWithSnapshot(_ module: PresentableProtocol?) {
        guard let controller = module?.toPresent() else { return }
        controller.modalPresentationStyle = .fullScreen
        
        self.rootController?.present(controller, animated: false, completion: nil)
    }
    
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func push(_ module: PresentableProtocol?) {
        push(module, animated: true)
    }
    
    func push(_ module: PresentableProtocol?, animated: Bool)  {
        push(module, animated: animated, completion: nil)
    }
    
    func push(_ module: PresentableProtocol?, animated: Bool, popModuleBySwipe: Bool = true, completion: (() -> Void)?) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        
        rootController?.interactivePopGestureRecognizer?.isEnabled = popModuleBySwipe
        
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func popModule()  {
        popModule(animated: true)
    }
    
    func popModule(animated: Bool)  {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func setRootModule(_ module: PresentableProtocol?) {
        setRootModule(module, hideBar: false)
    }
    
    func setRootModule(_ module: PresentableProtocol?, hideBar: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }
    
    func popToIntermediableRootModule(animated: Bool) {
        if let controller = rootController?.viewControllers.filter({ $0 is IntermediableProtocol && $0 !== self.rootController?.topViewController }).last {
            if let controllers = rootController?.popToViewController(controller, animated: animated) {
                controllers.forEach { controller in
                    runCompletion(for: controller)
                }
            }
        }
    }
    
    func popToRootModule(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    func snapshot() -> UIImage? {
        return self.rootController?.viewControllers.last?.view.asImage()
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}
