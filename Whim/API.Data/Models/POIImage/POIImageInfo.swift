//
//  POIImageDetails.swift
//  Whim
//
//  Created by Gica Gugui on 14/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import Foundation

public struct POIImageInfo: Codable {
    public var url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
    
    public init() {
        self.url = ""
    }
    
    public init(url: String) {
        self.url = url
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let url = try container.decode(String.self, forKey: .url)
        
        self.init(url: url)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(url, forKey: .url)
    }
}
