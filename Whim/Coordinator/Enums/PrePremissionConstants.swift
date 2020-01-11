//
//  PrePremissionConstants.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

struct PrePremissionConstants {
    static let CreatePrePermission = "createPrePermission"
}

enum PrePermissionHandlerOption {
    case createPrePermission(title: String, message: String, onAcceptButtonTap: (() -> ())?, onDenyButtonTap: (() -> ())?)
    
    static func build(type: String, title: String, message: String, onAcceptButtonTap: (() -> ())?, onDenyButtonTap: (() -> ())?) -> PrePermissionHandlerOption {
        switch type {
        case PrePremissionConstants.CreatePrePermission:
            return .createPrePermission(title: title, message: message, onAcceptButtonTap: onAcceptButtonTap, onDenyButtonTap: onDenyButtonTap)
        default:
            fatalError("PrePermissionHandlerOption cannot be constructed with type \(type)")
        }
    }
}
