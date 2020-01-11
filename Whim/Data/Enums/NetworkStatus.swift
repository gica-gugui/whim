//
//  NetworkStatus.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

public enum NetworkStatus {
    case unknown
    case notReachable
    case reachable(NetworkConnectionType)
}
