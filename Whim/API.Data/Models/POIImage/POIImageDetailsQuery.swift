//
//  POIImageDetailsQuery.swift
//  Whim
//
//  Created by Gica Gugui on 14/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

public struct POIImageDetailsQuery: Codable {
    public var pages: POIImagePage
    
    enum CodingKeys: String, CodingKey {
        case pages = "pages"
    }
    
    public init() {
        self.pages = POIImagePage()
    }
    
    public init(pages: POIImagePage) {
        self.pages = pages
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let pages = try container.decode(POIImagePage.self, forKey: .pages)
        
        self.init(pages: pages)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(pages, forKey: .pages)
    }
}
