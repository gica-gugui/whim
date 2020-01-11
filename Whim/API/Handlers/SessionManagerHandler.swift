//
//  SessionManagerHandler.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import Alamofire

public class SessionManagerHandler: SessionManager {
    fileprivate static var instance: SessionManager!
    
    public class func sharedInstance(configuration: URLSessionConfiguration) -> SessionManager {
        instance = (instance ?? SessionManager(configuration: configuration))
        return instance
    }
}
