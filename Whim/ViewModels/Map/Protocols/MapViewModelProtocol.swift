//
//  MapViewModelProtocol.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import CoreLocation
import MapKit

protocol MapViewModelProtocol {
    var onPoisLoaded: ((_ mapAnnotations: [MapAnnotation]) -> Void)? { get set }
    
    func loadPointOfInterests(location: CLLocation)
    func loadPointOfInterest(mapAnnotation: MapAnnotation)
    
    func getCenterLocation() -> CLLocation?
    func getAnnotationsRegion() -> MKCoordinateRegion?
}
