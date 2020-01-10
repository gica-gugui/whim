//
//  ModuleFactory.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit
import SwinjectStoryboard

typealias ModuleFactoryProtocol = LoadingModuleFactoryProtocol

final class ModuleFactory: ModuleFactoryProtocol {
    func makeLoadingOutput() -> LoadingViewProtocol {
        return LoadingViewController.controllerFromStoryboard(.main)
    }
}
