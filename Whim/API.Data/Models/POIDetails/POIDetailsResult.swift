//
//  POIDetailsQuery.swift
//  Whim
//
//  Created by Gica Gugui on 13/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

public struct POIDetailsResult: Codable {
    public var batchComplete: String
    public var query: POIDetailsQuery
    
    enum CodingKeys: String, CodingKey {
        case batchComplete = "batchcomplete"
        case query = "query"
    }
    
    public init() {
        self.batchComplete = ""
        self.query = POIDetailsQuery()
    }
    
    public init(batchComplete: String, query: POIDetailsQuery) {
        self.batchComplete = batchComplete
        self.query = query
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let batchComplete = try container.decode(String.self, forKey: .batchComplete)
        let query = try container.decode(POIDetailsQuery.self, forKey: .query)
        
        self.init(batchComplete: batchComplete, query: query)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(batchComplete, forKey: .batchComplete)
        try container.encode(query, forKey: .query)
    }
}
