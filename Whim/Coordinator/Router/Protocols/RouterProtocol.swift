//
//  RouterProtocol.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit

protocol RouterProtocol: PresentableProtocol {
    
    func present(_ module: PresentableProtocol?)
    func present(_ module: PresentableProtocol?, animated: Bool)
    func present(_ module: PresentableProtocol?, animated: Bool, presentationStyle: UIModalPresentationStyle)
    
    func push(_ module: PresentableProtocol?)
    func push(_ module: PresentableProtocol?, animated: Bool)
    func push(_ module: PresentableProtocol?, animated: Bool, popModuleBySwipe: Bool, completion: (() -> Void)?)
    
    func popModule()
    func popModule(animated: Bool)
    func popToIntermediableRootModule(animated: Bool)
    
    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    func setRootModule(_ module: PresentableProtocol?)
    func setRootModule(_ module: PresentableProtocol?, hideBar: Bool)
    
    func popToRootModule(animated: Bool)
    
    func snapshot() -> UIImage?
}
