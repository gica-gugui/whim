//
//  PrePermissionHandler.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit

class PrePermissionHandler: PrePermissionHandlerProtocol {
    var onPrePermissionCreated: ((PresentableProtocol) -> ())?
    
    func handle(with prePermissionHandlerOption: PrePermissionHandlerOption) {
        switch prePermissionHandlerOption {
        case let .createPrePermission(title: title, message: message, onAcceptButtonTap: onacceptButtonTap, onDenyButtonTap: onDenyButtonTap):
            let prePermissionView = createPrePremissionView(title: title, message: message, onAcceptButtonTap: onacceptButtonTap, onDenyButtonTap: onDenyButtonTap)
            onPrePermissionCreated?(prePermissionView)
        }
    }
    
    private func createPrePremissionView(title: String, message: String, onAcceptButtonTap: (() -> ())?, onDenyButtonTap: (() -> ())?) -> PresentableProtocol {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
        let acceptAction = UIAlertAction(title: NSLocalizedString("accept", comment: ""), style: .default) { _ in
            onAcceptButtonTap?()
        }
        alertView.addAction(acceptAction)
        
        let denyAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel) { _ in
            onDenyButtonTap?()
        }
        alertView.addAction(denyAction)
        
        return alertView
    }
}
