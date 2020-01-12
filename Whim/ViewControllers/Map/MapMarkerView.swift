//
//  MapViews.swift
//  Whim
//
//  Created by Gica Gugui on 12/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import MapKit

class MapMarkerView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? MapAnnotation else { return }
            
            if annotation.type == .currentLocation {
                tintColor = annotation.color
                markerTintColor = annotation.color
            } else {
                canShowCallout = true
                calloutOffset = CGPoint(x: -5, y: 5)
                rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            
            if let imageName = annotation.imageName {
                glyphImage = UIImage(named: imageName)
            }
        }
    }
}
