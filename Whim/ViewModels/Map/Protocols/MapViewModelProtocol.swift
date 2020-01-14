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
    var onModalStateChanged: ((_ state: MapDetailsState?) -> Void)? { get set }
    
    func loadPointOfInterests(location: CLLocation)
    func loadPointOfInterest(mapAnnotation: MapAnnotation)
    func loadDirections(alternateDirections: Bool)
    
    func setModalState(state: MapDetailsState)
    
    func isInDirectionsMode() -> Bool
    
    func getWikipediaLink() -> String?
    func getAnnotationsWithoutInteraction() -> [MapAnnotation]
    
    func getRegionForCenter() -> MKCoordinateRegion?
    func getRegionForAnnotation(_ coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion?
    func getTranslatedRegion(_ region: MKCoordinateRegion) -> MKCoordinateRegion
    func getTranslatedRegion(_ polylines: [MKPolyline]) -> MKCoordinateRegion?
    func getScaledRegion(_ region: MKCoordinateRegion) -> MKCoordinateRegion
}
