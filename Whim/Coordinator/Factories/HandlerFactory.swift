//
//  HandlerFactory.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit

typealias HandlerFactoryProtocol =
    ReachabilityHandlerFactoryProtocol &
    LocationHandlerFactoryProtocol &
    PrePermissionHandlerFactoryProtocol
    

final class HandlerFactory: HandlerFactoryProtocol {
    func getPrePermissionHandler() -> PrePermissionHandlerProtocol {
         return PrePermissionHandler()
    }
    
    func getReachabilityHandler() -> ReachabilityHandlerProtocol {
        return ReachabilityHandler()
    }
 
    func getLocationHandler() -> LocationHandlerProtocol {
        return LocationHandler()
    }
}
