//
//  PoiImagePage.swift
//  Whim
//
//  Created by Gica Gugui on 14/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

public struct POIImageItem: Codable {
    public var imageInfo: [POIImageInfo]
    
    enum CodingKeys: String, CodingKey {
        case imageInfo = "imageinfo"
    }
    
    public init() {
        self.imageInfo = [POIImageInfo]()
    }
    
    public init(imageInfo: [POIImageInfo]) {
        self.imageInfo = imageInfo
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let imageInfo = try container.decode([POIImageInfo].self, forKey: .imageInfo)
        
        self.init(imageInfo: imageInfo)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(imageInfo, forKey: .imageInfo)
    }
}
