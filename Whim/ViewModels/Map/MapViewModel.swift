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
    var onDirectionComputed: ((_ routes: [MKRoute]) -> Void)?
    
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
    
    func loadDirections() {
        guard let source = self.centerLocation, let poi = self.pointOfInterest else {
            return
        }
        
        let selectedAnnotations = self.mapAnnotations.filter { annotation in
            return annotation.pageId == poi.pageid
        }
        
        guard selectedAnnotations.count > 0, let destination = selectedAnnotations.first?.coordinate else {
            return
        }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: source.coordinate.latitude, longitude: source.coordinate.longitude), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
//        request.requestsAlternateRoutes = true
        request.transportType = .walking

        let directions = MKDirections(request: request)

        directions.calculate { [weak self] response, error in
            guard let routes = response?.routes else {
                return
            }
            
            self?.onDirectionComputed?(routes)
        }
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
    
    func getRegionForAnnotation(_ coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion? {
        guard let distance = self.annotationsMaxDistance else {
            return nil
        }
        
        return MKCoordinateRegion(center: coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
    }
    
    func getTranslatedRegion(_ region: MKCoordinateRegion) -> MKCoordinateRegion {
        let centerPointRegion = region.center
        
        let centerPointNewRegion = CLLocationCoordinate2D.init(latitude: centerPointRegion.latitude - region.span.latitudeDelta / 4.0, longitude: centerPointRegion.longitude)
        
        return MKCoordinateRegion(center: centerPointNewRegion, span: region.span)
    }

    func getTranslatedRegion(_ polyline: MKPolyline) -> MKCoordinateRegion {
        let region = MKCoordinateRegion.init(polyline.boundingMapRect)
        
        let scaledRegion = getScaledRegion(region)
        
        return getTranslatedRegion(scaledRegion)
    }
    
    func getScaledRegion(_ region: MKCoordinateRegion) -> MKCoordinateRegion {
        let spanRegion = region.span
        
        let spanNewRegion = MKCoordinateSpan(latitudeDelta: spanRegion.latitudeDelta * 2.5, longitudeDelta: spanRegion.longitudeDelta * 1.25)
        
        return MKCoordinateRegion(center: region.center, span: spanNewRegion)
    }
}
