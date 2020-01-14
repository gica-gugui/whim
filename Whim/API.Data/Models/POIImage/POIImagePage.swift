//
//  POIImagePage.swift
//  Whim
//
//  Created by Gica Gugui on 14/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

public struct POIImagePage: Codable {
    public var poiImageItem: POIImageItem
    
    public init() {
        self.poiImageItem = POIImageItem()
    }

    public init(poiImageItem: POIImageItem) {
        self.poiImageItem = poiImageItem
    }
    
    public init(from decoder: Decoder) throws {
        let dynamicKeysContainer = try decoder.container(keyedBy: DynamicKey.self)

        var poiImageItem = POIImageItem()
        if let key = dynamicKeysContainer.allKeys.first {
            poiImageItem = try dynamicKeysContainer.decode(POIImageItem.self, forKey: key)
        }
        
        self.init(poiImageItem: poiImageItem)
    }
}
