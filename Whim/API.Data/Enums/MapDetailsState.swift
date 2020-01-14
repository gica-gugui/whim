//
//  MapDetailsState.swift
//  Whim
//
//  Created by Gica Gugui on 14/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

struct MapDetailsConstants {
    static let Closed = "closed"
    static let Opened = "opened"
    static let Directions = "directions"
    static let Rooutes = "routes"
}

enum MapDetailsState: Equatable {
    case closed
    case opened(MapAnnotation)
    case directions
    case routes
    
    static func build(type: String) -> MapDetailsState {
        switch type {
        case MapDetailsConstants.Closed:
            return .closed
        case MapDetailsConstants.Directions:
            return .directions
        case MapDetailsConstants.Rooutes:
            return .routes
        default:
            fatalError("MapDetailsState cannot be constructed with type \(type)")
        }
    }
    
    static func build(type: String, annotation: MapAnnotation) -> MapDetailsState {
        switch type {
        case MapDetailsConstants.Opened:
            return .opened(annotation)
        default:
            fatalError("MapDetailsState cannot be constructed with type \(type)")
        }
    }
}
