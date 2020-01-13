//
//  POIImage.swift
//  Whim
//
//  Created by Gica Gugui on 13/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

public struct POIImage: Codable {
    public var ns: Int
    public var title: String
    
    enum CodingKeys: String, CodingKey {
        case ns = "ns"
        case title = "title"
    }
    
    public init() {
        self.ns = 0
        self.title = ""
    }
    
    public init(ns: Int, title: String) {
        self.ns = ns
        self.title = title
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let ns = try container.decode(Int.self, forKey: .ns)
        let title = try container.decode(String.self, forKey: .title)
        
        self.init(ns: ns, title: title)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(ns, forKey: .ns)
        try container.encode(title, forKey: .title)
    }
}
