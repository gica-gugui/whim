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
            
            tintColor = annotation.color
            markerTintColor = annotation.color
            
            if let imageName = annotation.imageName {
                glyphImage = UIImage(named: imageName)
            }
            
            if annotation.type == .currentLocation {
                displayPriority = .required
            }
        }
    }
}
