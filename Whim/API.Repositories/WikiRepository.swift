//
//  WikiRepository.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import RxSwift

public class WikiRepository: BaseRepository, WikiRepositoryProtocol {
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
}
