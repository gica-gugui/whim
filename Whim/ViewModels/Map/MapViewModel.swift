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
    private var wikiRepository: WikiRepositoryProtocol
    
    private var disposeBag = DisposeBag()
    
    init(wikiRepository: WikiRepository) {
        self.wikiRepository = wikiRepository
    }
    
    func loadPointOfInterests(location: CLLocation) {
        _ = wikiRepository.getPOIs(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            .subscribeOn(InfraHelper.backgroundWorkScheduler)
            .do(onError: { [weak self] error in
                print(error)
                // self?.handleError(error: error)
            })
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] poiResult in
                print(poiResult)
            })
            .disposed(by: disposeBag)
    }
}
