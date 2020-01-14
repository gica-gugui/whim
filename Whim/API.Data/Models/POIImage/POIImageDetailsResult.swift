//
//  POIImageDetailsResult.swift
//  Whim
//
//  Created by Gica Gugui on 14/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

public struct POIImageDetailsResult: Codable {
    public var query: POIImageDetailsQuery
    
    enum CodingKeys: String, CodingKey {
        case query = "query"
    }
    
    public init() {
        self.query = POIImageDetailsQuery()
    }
    
    public init(query: POIImageDetailsQuery) {
        self.query = query
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let query = try container.decode(POIImageDetailsQuery.self, forKey: .query)
        
        self.init(query: query)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(query, forKey: .query)
    }
}
