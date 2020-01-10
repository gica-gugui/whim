//
//  LoadingViewController.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit

class LoadingViewController: BaseViewController, LoadingViewProtocol {
    var onCompleteLoad: (() -> ())?
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        showAnimation()
    }
    
    private func showAnimation() {
        onCompleteLoad?()
    }
}
