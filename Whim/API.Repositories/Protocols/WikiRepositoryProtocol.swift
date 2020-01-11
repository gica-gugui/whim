//
//  WikiRepositoryProtocol.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import RxSwift

public protocol WikiRepositoryProtocol {
    func getPOIs(latitude: Double, longitude: Double) -> Observable<POIResult>
}
