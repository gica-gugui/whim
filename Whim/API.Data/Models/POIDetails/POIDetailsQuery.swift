//
//  POIPages.swift
//  Whim
//
//  Created by Gica Gugui on 13/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//


public struct POIDetailsQuery: Codable {
    public var pages: POIPage
    
    enum CodingKeys: String, CodingKey {
        case pages = "pages"
    }
    
    public init() {
        self.pages = POIPage()
    }
    
    public init(pages: POIPage) {
        self.pages = pages
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let pages = try container.decode(POIPage.self, forKey: .pages)
        
        self.init(pages: pages)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(pages, forKey: .pages)
    }
}
