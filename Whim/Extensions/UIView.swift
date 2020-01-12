//
//  UIView.swift
//  Whim
//
//  Created by Gica Gugui on 12/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit

extension UIView  {
    // render the view within the view's bounds, then capture it as image
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image(actions: { rendererContext in
            layer.render(in: rendererContext.cgContext)
        })
    }
}
