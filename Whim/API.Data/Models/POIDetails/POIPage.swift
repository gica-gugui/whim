//
//  POIPage.swift
//  Whim
//
//  Created by Gica Gugui on 13/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

public struct POIPage: Codable {
    public var poiDetails: POIDetails
    
    public init() {
        self.poiDetails = POIDetails()
    }

    public init(poiDetails: POIDetails) {
        self.poiDetails = poiDetails
    }
    
    public init(from decoder: Decoder) throws {
        let dynamicKeysContainer = try decoder.container(keyedBy: DynamicKey.self)

        var poiDetails = POIDetails()
        if let key = dynamicKeysContainer.allKeys.first {
            poiDetails = try dynamicKeysContainer.decode(POIDetails.self, forKey: key)
        }
        
        self.init(poiDetails: poiDetails)
    }
}

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
