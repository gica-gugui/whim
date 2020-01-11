//
//  PointOfInterest.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

public struct POI: Codable {
    public var pageid: Int
    public var ns: Int
    public var title: String
    public var lat: Double
    public var lon: Double
    public var dist: Double
    public var primary: String
    
    enum CodingKeys: String, CodingKey {
        case pageid = "pageid"
        case ns = "ns"
        case title = "title"
        case lat = "lat"
        case lon = "lon"
        case dist = "dist"
        case primary = "primary"
    }
    
    public init() {
        self.pageid = 0
        self.ns = 0
        self.title = ""
        self.lat = 0
        self.lon = 0
        self.dist = 0
        self.primary = ""
    }
    
    public init(pageid: Int, ns: Int, title: String, lat: Double, lon: Double, dist: Double, primary: String) {
        self.pageid = pageid
        self.ns = ns
        self.title = title
        self.lat = lat
        self.lon = lon
        self.dist = dist
        self.primary = primary
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let pageid = try container.decode(Int.self, forKey: .pageid)
        let ns = try container.decode(Int.self, forKey: .ns)
        let title = try container.decode(String.self, forKey: .title)
        let lat = try container.decode(Double.self, forKey: .lat)
        let lon = try container.decode(Double.self, forKey: .lon)
        let dist = try container.decode(Double.self, forKey: .dist)
        let primary = try container.decode(String.self, forKey: .primary)
        
        self.init(pageid: pageid, ns: ns, title: title, lat: lat, lon: lon, dist: dist, primary: primary)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(pageid, forKey: .pageid)
        try container.encode(ns, forKey: .ns)
        try container.encode(title, forKey: .title)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
        try container.encode(dist, forKey: .dist)
        try container.encode(primary, forKey: .primary)
    }
}
