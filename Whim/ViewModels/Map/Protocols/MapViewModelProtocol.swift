//
//  MapViewModelProtocol.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import CoreLocation

protocol MapViewModelProtocol {
    var onPoisLoaded: ((_ pois: [POI]) -> Void)? { get set }
    
    func loadPointOfInterests(location: CLLocation)
}
