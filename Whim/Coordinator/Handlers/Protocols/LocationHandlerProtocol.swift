//
//  LocationHandlerProtocol.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import CoreLocation

protocol LocationHandlerProtocol: HandlerProtocol {
    func handle(with locationOption: LocationHandlerOption)
    
    var onDidUpdateLocations: (([CLLocation]) -> ())? { get set }
    var onPermissionStatusObtained: ((CLAuthorizationStatus) -> ())? { get set }
    var onRequestPermissionComplete: (() -> ())? { get set }
}
