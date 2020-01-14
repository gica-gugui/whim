//
//  MapViewType.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

struct MapViewTypeConstants {
    static let CurrentLocation = "currentLocation"
    static let POI = "pointOfInterest"
}

enum MapViewType {
    case currentLocation
    case poi
    
    static func build(type: String) -> MapViewType {
        switch type {
        case MapViewTypeConstants.CurrentLocation:
            return .currentLocation
        case MapViewTypeConstants.POI:
            return .poi
        default:
            fatalError("MapViewType cannot be constructed with type \(type)")
        }
    }
}
