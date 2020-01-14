//
//  WikiRepository.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import RxSwift

public class WikiRepository: BaseRepository, WikiRepositoryProtocol {
    public func getPOI(pageId: Int) -> Observable<POIDetailsResult> {
        let headers = [
            "Content-type": "application/json"
        ]

        let parameters = [
            "action": "query",
            "prop": "info%7Cdescription%7Cimages",
            "pageids": "\(pageId)",
            "format": "json"
        ]
        
        let url = ApiHelper.getURL(BaseUrl.Wiki, action: Action.Wikipedia.PointOfInterests, parameters: parameters)

        return api.executeRequest(url: url!, method: .get, headers: headers, body: nil)
    }
    
    public func getPOIs(latitude: Double, longitude: Double) -> Observable<POIResult> {
        let headers = [
            "Content-type": "application/json"
        ]

        let parameters = [
            "action": "query",
            "list": "geosearch",
            "gsradius": "10000",
            "gscoord": "\(latitude)%7C\(longitude)",
            "gslimit": "50",
            "format": "json"
        ]
        
        let url = ApiHelper.getURL(BaseUrl.Wiki, action: Action.Wikipedia.PointOfInterests, parameters: parameters)

        return api.executeRequest(url: url!, method: .get, headers: headers, body: nil)
    }
    
    public func getPOIImage(filename: String) -> Observable<POIImageDetailsResult> {
        let headers = [
            "Content-type": "application/json"
        ]

        let encodedFilename = filename.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let parameters = [
            "action": "query",
            "prop": "imageinfo",
            "titles": "\(encodedFilename)",
            "iiprop": "url",
            "format": "json"
        ]
        
        let url = ApiHelper.getURL(BaseUrl.Wiki, action: Action.Wikipedia.PointOfInterests, parameters: parameters)

        return api.executeRequest(url: url!, method: .get, headers: headers, body: nil)
    }
}
