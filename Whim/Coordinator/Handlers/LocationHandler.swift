//
//  LocationHandler.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import CoreLocation

class LocationHandler: NSObject, LocationHandlerProtocol {
    var onDidUpdateLocations: (([CLLocation]) -> ())?
    var onPermissionStatusObtained: ((CLAuthorizationStatus) -> ())?
    var onRequestPermissionComplete: (() -> ())?
    
    private var manager: CLLocationManager!
    private var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        
        DispatchQueue.main.async {
            self.authorizationStatus = CLLocationManager.authorizationStatus()
            
            self.manager = CLLocationManager()
            self.manager.delegate = self
        }
    }
    
    func handle(with locationOption: LocationHandlerOption) {
        switch locationOption {
        case .permissionStatus:
            permissionStatus()
        case .requestPermission:
            requestPermission()
        case .retrieveLocation:
            retrieveLocation()
        }
    }
    
    private func requestPermission() {
        DispatchQueue.main.async {
            guard CLLocationManager.authorizationStatus() == .notDetermined
                else {
                    self.onRequestPermissionComplete?()
                    
                    return
            }
            
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    private func permissionStatus() {
        DispatchQueue.main.async {
            let permissionStatus = CLLocationManager.authorizationStatus()
            
            self.onPermissionStatusObtained?(permissionStatus)
        }
    }
    
    private func retrieveLocation() {
        DispatchQueue.main.async {
            guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse
                else {
                    self.onDidUpdateLocations?([])
                    
                    return
            }
            
            self.manager.requestLocation()
        }
    }
}

extension LocationHandler: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == self.authorizationStatus {
            return
        }
        
        onRequestPermissionComplete?()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        onDidUpdateLocations?(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onDidUpdateLocations?([])
    }
}
