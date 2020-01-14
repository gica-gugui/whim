//
//  DynamicKey.swift
//  Whim
//
//  Created by Gica Gugui on 14/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

struct DynamicKey: CodingKey {
    var intValue: Int?
    var stringValue: String
    
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
}
