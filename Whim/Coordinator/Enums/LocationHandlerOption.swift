//
//  LocationHandlerOption.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import CoreLocation

struct LocationConstants {
    static let RequestPermission = "requestPermission"
    static let PermissionStatus = "permissionStatus"
    static let RetrieveLocation = "retrieveLocation"
}

enum LocationHandlerOption {
    case requestPermission
    case permissionStatus
    case retrieveLocation
    
    static func build(type: String) -> LocationHandlerOption {
        switch type {
        case LocationConstants.RequestPermission:
            return .requestPermission
        case LocationConstants.PermissionStatus:
            return .permissionStatus
        case LocationConstants.RetrieveLocation:
            return .retrieveLocation
        default:
            fatalError("LocationHandlerOption cannot be constructed with type \(type)")
        }
    }
}
