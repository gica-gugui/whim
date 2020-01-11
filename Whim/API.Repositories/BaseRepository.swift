//
//  BaseRepository.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

open class BaseRepository {
    public var api: ApiProtocol!
    
    public func cancellAllRequests() {
        api.cancelAllRequests()
    }
}
