//
//  POIDetails.swift
//  Whim
//
//  Created by Gica Gugui on 13/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import Foundation

public struct POIDetails: Codable {
    public var pageid: Int
    public var ns: Int
    public var title: String
    public var contentModel: String
    public var pageLanguage: String
    public var pageLanguageHtmlCode: String
    public var pageLanguageDir: String
    public var touched: Date?
    public var lastRevId: Int
    public var length: Int
    public var description: String?
    public var descriptionSource: String?
    public var images: [POIImage]?
    
    enum CodingKeys: String, CodingKey {
        case pageid = "pageid"
        case ns = "ns"
        case title = "title"
        case contentModel = "contentmodel"
        case pageLanguage = "pagelanguage"
        case pageLanguageHtmlCode = "pagelanguagehtmlcode"
        case pageLanguageDir = "pagelanguagedir"
        case touched = "touched"
        case lastRevId = "lastrevid"
        case length = "length"
        case description = "description"
        case descriptionSource = "descriptionsource"
        case images = "images"
    }
    
    public init() {
        self.pageid = 0
        self.ns = 0
        self.title = ""
        self.contentModel = ""
        self.pageLanguage = ""
        self.pageLanguageHtmlCode = ""
        self.pageLanguageDir = ""
        self.touched = nil
        self.lastRevId = 0
        self.length = 0
        self.description = nil
        self.descriptionSource = nil
        self.images = nil
    }
    
    public init(pageid: Int, ns: Int, title: String, contentModel: String, pageLanguage: String, pageLanguageHtmlCode: String, pageLanguageDir: String, touched: Date?, lastRevId: Int, length: Int, description: String?, descriptionSource: String?, images: [POIImage]?) {
        self.pageid = pageid
        self.ns = ns
        self.title = title
        self.contentModel = contentModel
        self.pageLanguage = pageLanguage
        self.pageLanguageDir = pageLanguageDir
        self.pageLanguageHtmlCode = pageLanguageHtmlCode
        self.touched = touched
        self.lastRevId = lastRevId
        self.length = length
        self.description = description
        self.descriptionSource = descriptionSource
        self.images = images
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let pageid = try container.decode(Int.self, forKey: .pageid)
        let ns = try container.decode(Int.self, forKey: .ns)
        let title = try container.decode(String.self, forKey: .title)
        let contentModel = try container.decode(String.self, forKey: .contentModel)
        let pageLanguage = try container.decode(String.self, forKey: .pageLanguage)
        let pageLanguageDir = try container.decode(String.self, forKey: .pageLanguageDir)
        let pageLanguageHtmlCode = try container.decode(String.self, forKey: .pageLanguageHtmlCode)
        let touched = try container.decodeIfPresent(Date.self, forKey: .touched)
        let lastRevId = try container.decode(Int.self, forKey: .lastRevId)
        let length = try container.decode(Int.self, forKey: .length)
        let description = try container.decodeIfPresent(String.self, forKey: .description)
        let descriptionSource = try container.decodeIfPresent(String.self, forKey: .descriptionSource)
        let images = try container.decodeIfPresent([POIImage].self, forKey: .images)
        
        self.init(pageid: pageid, ns: ns, title: title, contentModel: contentModel, pageLanguage: pageLanguage, pageLanguageHtmlCode: pageLanguageHtmlCode, pageLanguageDir: pageLanguageDir, touched: touched, lastRevId: lastRevId, length: length, description: description, descriptionSource: descriptionSource, images: images)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(pageid, forKey: .pageid)
        try container.encode(ns, forKey: .ns)
        try container.encode(title, forKey: .title)
        try container.encode(pageLanguage, forKey: .pageLanguage)
        try container.encode(pageLanguageDir, forKey: .pageLanguageDir)
        try container.encode(pageLanguageHtmlCode, forKey: .pageLanguageHtmlCode)
        try container.encode(touched, forKey: .touched)
        try container.encode(lastRevId, forKey: .lastRevId)
        try container.encode(touched, forKey: .touched)
        try container.encode(length, forKey: .length)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(descriptionSource, forKey: .descriptionSource)
        try container.encodeIfPresent(images, forKey: .images)
    }
}
