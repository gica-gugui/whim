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
        var maxDistance = 0.0
        
        for poi in pois {
            let poiAnnotation = MapAnnotation(
                title: poi.title,
                type: .poi,
                coordinate: CLLocationCoordinate2D(latitude: poi.lat, longitude: poi.lon))
            
            poiAnnotations.append(poiAnnotation)
            
            if poi.dist > maxDistance {
                maxDistance = poi.dist
            }
        }
        
        mapView.addAnnotations(poiAnnotations)
        
        guard let centerLocation = self.viewModel.getCenterLocation() else {
            return
        }
        
        let centerRegion = MKCoordinateRegion(center: centerLocation.coordinate, latitudinalMeters: maxDistance, longitudinalMeters: maxDistance)
        
        mapView.setRegion(centerRegion, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {

}

