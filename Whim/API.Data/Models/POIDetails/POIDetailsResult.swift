//
//  POIDetailsQuery.swift
//  Whim
//
//  Created by Gica Gugui on 13/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

public struct POIDetailsResult: Codable {
    public var query: POIDetailsQuery
    
    enum CodingKeys: String, CodingKey {
        case query = "query"
    }
    
    public init() {
        self.query = POIDetailsQuery()
    }
    
    public init(query: POIDetailsQuery) {
        self.query = query
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let query = try container.decode(POIDetailsQuery.self, forKey: .query)
        
        self.init(query: query)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(query, forKey: .query)
    }
}
