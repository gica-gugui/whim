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
    var onPoiLoaded: ((_ poi: POIDetails) -> Void)?
    
    private var wikiRepository: WikiRepositoryProtocol
    
    private var disposeBag = DisposeBag()
    
    private var centerLocation: CLLocation?
    private var annotationsMaxDistance: Double?
    private var mapAnnotations = [MapAnnotation]()
    private var pointOfInterest: POIDetails?
    
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
        
        _ = wikiRepository.getPOI(pageId: pageId)
            .subscribeOn(InfraHelper.backgroundWorkScheduler)
            .do(onError: { error in
                print(error)
            })
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] result in
                let poi = result.query.pages.poiDetails
                
                self?.pointOfInterest = poi
                self?.onPoiLoaded?(poi)
            })
            .disposed(by: disposeBag)
    }
    
    func getWikipediaLink() -> String? {
        guard let pointOfInterest = self.pointOfInterest, let titleUrlEncoded = pointOfInterest.title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }
        
        return "https://en.wikipedia.org/wiki/\(titleUrlEncoded)"
    }
    
    func getCenterLocation() -> CLLocation? {
        return self.centerLocation
    }
    
    func getAnnotationsMaxDistance() -> Double? {
        return self.annotationsMaxDistance
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
        
        self.annotationsMaxDistance = maxDistance
        
        return MKCoordinateRegion(center: centerLocation.coordinate, latitudinalMeters: maxDistance, longitudinalMeters: maxDistance)
    }
}
