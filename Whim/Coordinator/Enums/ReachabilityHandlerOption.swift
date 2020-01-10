//
//  ReachabilityHandlerOption.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

struct ReachabilityConstants {
    static let StartListening = "startListening"
    static let StopListening = "stopListening"
}

enum ReachabilityHandlerOption {
    case startListening
    case stopListening
    
    static func build(type: String) -> ReachabilityHandlerOption {
        switch type {
        case ReachabilityConstants.StartListening:
            return .startListening
        case ReachabilityConstants.StopListening:
            return .stopListening
        default:
            fatalError("ReachabilityHandlerOption cannot be constructed with type \(type)")
        }
    }
}
