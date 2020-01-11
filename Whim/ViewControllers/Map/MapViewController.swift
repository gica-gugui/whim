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
        viewModel.onPoisLoaded = { [weak self] pois in
             self?.setPois(pois: pois)
        }
    }
    
    func locationObtained(location: CLLocation) {
        setCurrentLocation(location: location)
        
        viewModel.loadPointOfInterests(location: location)
    }
    
    private func setCurrentLocation(location: CLLocation) {
        let mapAnnotation = MapAnnotation(
            title: "Current location",
            type: .currentLocation,
            coordinate: location.coordinate)
            
        mapView.addAnnotation(mapAnnotation)
        
        mapView.setCenter(location.coordinate, animated: true)
    }
    
    private func setPois(pois:[POI]) {
        var poiAnnotations = [MapAnnotation]()
        
        for poi in pois {
            let poiAnnotation = MapAnnotation(
                title: poi.title,
                type: .poi,
                coordinate: CLLocationCoordinate2D(latitude: poi.lat, longitude: poi.lon))
            
            poiAnnotations.append(poiAnnotation)
        }
        
        mapView.addAnnotations(poiAnnotations)
    }
}

extension MapViewController: MKMapViewDelegate {

}

