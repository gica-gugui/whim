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
    var onPoiLoaded: ((_ poi: POIDetails) -> Void)? { get set }
    var onDirectionComputed: ((_ routes: [MKRoute]) -> Void)? { get set }
    
    func loadPointOfInterests(location: CLLocation)
    func loadPointOfInterest(mapAnnotation: MapAnnotation)
    func loadDirections()
    
    func getCenterLocation() -> CLLocation?
    func getAnnotationsRegion() -> MKCoordinateRegion?
    func getWikipediaLink() -> String?
    func getAnnotationsMaxDistance() -> Double?
}
