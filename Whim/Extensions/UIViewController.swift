//
//  UIViewController.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

//import SwinjectStoryboard
//
//extension UIViewController {
//    private class func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
//        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
//    }
//    
//    class func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
//        return instantiateControllerInStoryboard(storyboard, identifier: identifier)
//    }
//    
//    class func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
//        return controllerInStoryboard(storyboard, identifier: nameOfClass)
//    }
//    
//    class func controllerFromStoryboard(_ storyboard: Storyboards) -> Self {
//        return controllerInStoryboard(SwinjectStoryboard.create(name: storyboard.rawValue, bundle: nil), identifier: nameOfClass)
//    }
//}
