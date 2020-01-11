//
//  POIQuery.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

public struct POIQuery: Codable {
    public var geosearch: [POI]
    
    enum CodingKeys: String, CodingKey {
        case geosearch = "geosearch"
    }
    
    public init() {
        self.geosearch = [POI]()
    }
    
    public init(geosearch: [POI]) {
        self.geosearch = geosearch
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let geosearch = try container.decode([POI].self, forKey: .geosearch)
        
        self.init(geosearch: geosearch)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(geosearch, forKey: .geosearch)
    }
}
