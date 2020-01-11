//
//  MapViewController.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController, MapViewProtocol, IntermediableProtocol {
    @IBOutlet private weak var mapView: MKMapView!
    
    var viewModel: MapViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupViewModel()
    }
    
    private func setupViewModel() {
        // set delegates here
        // when receiving the locations from api
    }
    
    func loadPointOfInterests(location: CLLocation) {
        viewModel.loadPointOfInterests(location: location)
    }
}
