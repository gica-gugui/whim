//
//  ApiProtocol.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import Alamofire
import RxSwift

public protocol ApiProtocol {
    func executeRequest<T>(url: URL, method: HTTPMethod, headers: [String: String]?, body: Data?) -> Observable<T> where T: Codable
    
    func cancelAllRequests()
}
