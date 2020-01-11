//
//  MapViewModel.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import CoreLocation
import RxSwift

class MapViewModel: MapViewModelProtocol {
    init() {
        // dependencies here
    }
    
    func loadPointOfInterests(location: CLLocation) {
        // call api with location info
        print("now call api cause I have a location")
    }
}
