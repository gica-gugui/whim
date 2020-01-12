//
//  MapView.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    let title: String?
    let type: MapViewType
    let coordinate: CLLocationCoordinate2D
    let color: UIColor
    let pageId: Int?

    init(title: String?, type: MapViewType, coordinate: CLLocationCoordinate2D, color: UIColor, pageId: Int?) {
        self.title = title
        self.type = type
        self.coordinate = coordinate
        self.color = color
        self.pageId = pageId

        super.init()
      }

    init?(poi: POI) {
        self.title = poi.title
        self.type = .poi
        self.coordinate = CLLocationCoordinate2D(latitude: poi.lat, longitude: poi.lon)
        self.color = UIColor.systemRed
        self.pageId = poi.pageid
    }
    
    var imageName: String? {
        return type == .currentLocation ? "Flag" : nil
    }
}
