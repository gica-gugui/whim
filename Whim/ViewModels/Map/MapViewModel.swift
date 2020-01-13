//
//  MapViewModel.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import CoreLocation
import MapKit
import RxSwift

class MapViewModel: MapViewModelProtocol {
    var onPoisLoaded: ((_ mapAnnotations: [MapAnnotation]) -> Void)?
    
    private var wikiRepository: WikiRepositoryProtocol
    
    private var disposeBag = DisposeBag()
    
    private var centerLocation: CLLocation?
    private var mapAnnotation: MapAnnotation?
    private var mapAnnotations = [MapAnnotation]()
    
    init(wikiRepository: WikiRepository) {
        self.wikiRepository = wikiRepository
    }
    
    func loadPointOfInterests(location: CLLocation) {
        self.centerLocation = location
        
        _ = wikiRepository.getPOIs(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            .subscribeOn(InfraHelper.backgroundWorkScheduler)
            .flatMap { poiResult in
                Observable.from(optional: poiResult.query.geosearch)
            }
            .map { pois in
                return pois.map { poi -> MapAnnotation in
                    return MapAnnotation.init(poi: poi)!
                }
            }
            .do(onError: { error in
                print(error)
            })
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] mapAnnotations in
                self?.mapAnnotations = mapAnnotations
                self?.onPoisLoaded?(mapAnnotations)
            })
            .disposed(by: disposeBag)
    }
    
    func loadPointOfInterest(mapAnnotation: MapAnnotation) {
        guard let pageId = mapAnnotation.pageId else {
            return
        }
        
        self.mapAnnotation = mapAnnotation
        
        _ = wikiRepository.getPOI(pageId: pageId)
            .subscribeOn(InfraHelper.backgroundWorkScheduler)
            .do(onError: { error in
                print(error)
            })
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] poiDetails in
                print(poiDetails)
            })
            .disposed(by: disposeBag)
    }
    
    func getCenterLocation() -> CLLocation? {
        return self.centerLocation
    }
    
    func getAnnotationsRegion() -> MKCoordinateRegion? {
        var maxDistance = 0.0
        
        for annotation in mapAnnotations {
            if annotation.distance > maxDistance {
                maxDistance = annotation.distance
            }
        }

        guard let centerLocation = self.centerLocation else {
            return nil
        }
        
        return MKCoordinateRegion(center: centerLocation.coordinate, latitudinalMeters: maxDistance, longitudinalMeters: maxDistance)
    }
}
