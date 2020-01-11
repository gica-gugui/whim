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

    init(title: String?, type: MapViewType, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.type = type
        self.coordinate = coordinate

        super.init()
      }

    init?(poi: POI) {
        self.title = poi.title
        self.type = .poi
        self.coordinate = CLLocationCoordinate2D(latitude: poi.lat, longitude: poi.lon)
    }

  var imageName: String? {
    switch self.type {
    case .currentLocation:
        return "Flag"
    default:
        return "Pinpoint"
    }
  }

  func mapItem() -> MKMapItem {
    let placemark = MKPlacemark(coordinate: coordinate)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = title
    
    return mapItem
  }

}
