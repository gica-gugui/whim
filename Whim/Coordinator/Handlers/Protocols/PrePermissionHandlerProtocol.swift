//
//  PrePermissionHandlerProtocol.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

protocol PrePermissionHandlerProtocol: HandlerProtocol {
    func handle(with prePermissionHandlerOption: PrePermissionHandlerOption)
    
    var onPrePermissionCreated: ((PresentableProtocol) -> ())? { get set }
}
