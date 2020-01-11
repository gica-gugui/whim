//
//  ApiError.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import Alamofire

public class ApiError: NSError {
    public var message: String?
    
    public init(error: Error, data: Data?){
        if let err = error as? AFError {
            super.init(domain: "", code: err.responseCode!, userInfo: nil)
        } else {
            let err = error as NSError
            super.init(domain: err.domain, code: err.code, userInfo: err.userInfo)
        }

        
        message = networkError(data: data)
    }
    
    private func networkError(data: Data?) -> String {
        guard let data = data, let errorMessage = String(data: data, encoding: .utf8), !errorMessage.isEmpty else {
            return NSLocalizedString("errorOccurred" , comment: "")
        }
        
        return errorMessage
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
