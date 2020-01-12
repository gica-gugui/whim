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
    
    private var annotationReuseIdentifier = "mapAnnotationIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        setupViewModel()
    }
    
    private func setupViewController() {
        mapView.delegate = self
        
        mapView.register(MapMarkerView.self, forAnnotationViewWithReuseIdentifier: annotationReuseIdentifier)
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
            title: NSLocalizedString("mapAnnotation.title", comment: ""),
            type: .currentLocation,
            coordinate: location.coordinate,
            color: UIColor.green)
            
        mapView.addAnnotation(mapAnnotation)
        
        mapView.setCenter(location.coordinate, animated: true)
    }
    
    private func setPois(pois:[POI]) {
        var poiAnnotations = [MapAnnotation]()
        var maxDistance = 0.0
        
        for poi in pois {
            let poiAnnotation = MapAnnotation.init(poi: poi)!
            
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
      func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapAnnotation else { return nil }
        
        var view: MKMarkerAnnotationView
        
        guard let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier) as? MKMarkerAnnotationView else {
            return nil
        }
        
        dequeuedView.annotation = annotation
        view = dequeuedView
        
        return view
      }
    
    //TODO redo this with coordinator
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let detailsViewcontroller = DetailsViewController.controllerFromStoryboard(.main)
        
        // set the modal presentation to full screen, in iOS 13, its no longer full screen by default
        detailsViewcontroller.modalPresentationStyle = .fullScreen
        
        // Delay the capture of snapshot by 0.1 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 , execute: {
            detailsViewcontroller.backingImage = self.navigationController?.view.asImage()
          
            // present the view controller modally without animation
            self.present(detailsViewcontroller, animated: false, completion: nil)
        })
    }
}

