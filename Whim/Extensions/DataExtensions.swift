//
//  DataExtensions.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import Foundation

public extension Data {
    func forDecoding() -> Data {
        if let emptyResult = String(data: self, encoding: .utf8), emptyResult.isEmpty {
            return "{}".data(using: .utf8)!
        }
        
        return self
    }
}
