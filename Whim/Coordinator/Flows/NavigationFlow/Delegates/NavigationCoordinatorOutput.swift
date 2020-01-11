//
//  NavigationCoordinatorOutput.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

protocol NavigationCoordinatorOutput: class {
    var finishFlow: (() -> Void)? { get set }
}

