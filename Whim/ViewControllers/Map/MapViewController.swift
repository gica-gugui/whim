//
//  MapViewController.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController, MapViewProtocol, IntermediableProtocol {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var separatorTopConstraint: NSLayoutConstraint!
    
    var onPOIDetailsTap: ((_ annotation: MapAnnotation) -> Void)?
    
    var viewModel: MapViewModelProtocol!
    
    private var annotationReuseIdentifier = "mapAnnotationIdentifier"
    
    // default card view state is normal
    private var cardViewState : CardViewState = .normal

    // to store the card view top constraint value before the dragging start
    // default is 30 pt from safe area top
    private var cardPanStartingTopConstant : CGFloat = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        setupViewModel()
    }
    
    private func setupViewController() {
        mapView.delegate = self
        
        mapView.register(MapMarkerView.self, forAnnotationViewWithReuseIdentifier: annotationReuseIdentifier)
        
        // round the handle view
        handleView.clipsToBounds = true
        handleView.layer.cornerRadius = 3.0

        // round the top left and top right corner of card view
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 10.0
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        // hide the card view at the bottom when the View first load
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height, let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
            separatorTopConstraint.constant = cardViewTopConstraint.constant / 2
        }

        // set dimmerview to transparent
        dimmerView.alpha = 0.0

        // dimmerViewTapped() will be called when user tap on the dimmer view
        let dimmerTap = UITapGestureRecognizer(target: self, action: #selector(dimmerViewTapped(_:)))
        dimmerView.addGestureRecognizer(dimmerTap)
        dimmerView.isUserInteractionEnabled = true

        // add pan gesture recognizer to the view controller's view (the whole screen)
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))

        // by default iOS will delay the touch before recording the drag/pan information
        // we want the drag gesture to be recorded down immediately, hence setting no delay
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false

        self.cardView.addGestureRecognizer(viewPan)
    }
    
    private func setupViewModel() {
        viewModel.onPoisLoaded = { [weak self] pois in
             self?.setPois(pois: pois)
        }
    }
    
    func locationObtained(location: CLLocation) {
        setCurrentLocation(location: location)
        
        viewModel.loadPointOfInterests(location: location)
    }
    
    private func setCurrentLocation(location: CLLocation) {
        let mapAnnotation = MapAnnotation(
            title: NSLocalizedString("mapAnnotation.title", comment: ""),
            type: .currentLocation,
            coordinate: location.coordinate,
            color: UIColor.systemGreen,
            pageId: nil)
            
        mapView.addAnnotation(mapAnnotation)
        
        mapView.setCenter(location.coordinate, animated: true)
    }
    
    private func setPois(pois:[POI]) {
        var poiAnnotations = [MapAnnotation]()
        var maxDistance = 0.0
        
        for poi in pois {
            let poiAnnotation = MapAnnotation.init(poi: poi)!
            
            poiAnnotations.append(poiAnnotation)
            
            if poi.dist > maxDistance {
                maxDistance = poi.dist
            }
        }
        
        mapView.addAnnotations(poiAnnotations)
        
        guard let centerLocation = self.viewModel.getCenterLocation() else {
            return
        }
        
        let centerRegion = MKCoordinateRegion(center: centerLocation.coordinate, latitudinalMeters: maxDistance, longitudinalMeters: maxDistance)
        
        mapView.setRegion(centerRegion, animated: true)
    }
}

// MapViewDelegate
extension MapViewController: MKMapViewDelegate {
      func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapAnnotation else { return nil }
        
        var view: MKMarkerAnnotationView
        
        guard let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier) as? MKMarkerAnnotationView else {
            return nil
        }
        
        dequeuedView.annotation = annotation
        view = dequeuedView
        
        return view
      }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        guard let mapAnnotation = view.annotation as? MapAnnotation else {
//            return
//        }
        
        showCard()
//        onPOIDetailsTap?(mapAnnotation)
    }
}

// Modal handling
extension MapViewController {
    @IBAction func dimmerViewTapped(_ sender: UITapGestureRecognizer) {
        hideCardAndGoBack()
    }
    
    @IBAction func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
        let velocity = panRecognizer.velocity(in: self.view)
        let translation = panRecognizer.translation(in: self.view)
      
        switch panRecognizer.state {
            case .began:
                cardPanStartingTopConstant = cardViewTopConstraint.constant
            
            case .changed:
                if self.cardPanStartingTopConstant + translation.y > 30.0 {
                    self.cardViewTopConstraint.constant = self.cardPanStartingTopConstant + translation.y
            }
            
            // change the dimmer view alpha based on how much user has dragged
            dimmerView.alpha = dimAlphaWithCardTopConstraint(value: self.cardViewTopConstraint.constant)

            case .ended:
                if velocity.y > 1500.0 {
                    hideCardAndGoBack()
                    return
                }
            
                if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
                    let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                  
                    if self.cardViewTopConstraint.constant < (safeAreaHeight + bottomPadding) * 0.25 {
                    showCard(atState: .expanded)
                    } else if self.cardViewTopConstraint.constant < (safeAreaHeight) - 70 {
                        showCard(atState: .normal)
                    } else {
                        hideCardAndGoBack()
                    }
                }
            default:
                break
        }
    }
    
    // default to show card at normal state, if showCard() is called without parameter
    private func showCard(atState: CardViewState = .normal) {
        // ensure there's no pending layout changes before animation runs
        self.view.layoutIfNeeded()
      
        // set the new top constraint value for card view
        // card view won't move up just yet, we need to call layoutIfNeeded()
        // to tell the app to refresh the frame/position of card view
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
        
            if atState == .expanded {
                // if state is expanded, top constraint is 30pt away from safe area top
                cardViewTopConstraint.constant = 30.0
            } else {
                cardViewTopConstraint.constant = (safeAreaHeight + bottomPadding) / 2.0
            }
        
            cardPanStartingTopConstant = cardViewTopConstraint.constant
        }
      
        // move card up from bottom
        // create a new property animator
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
      
        // show dimmer view
        // this will animate the dimmerView alpha together with the card move up animation
        showCard.addAnimations {
            self.dimmerView.alpha = 0.7
        }
      
        // run the animation
        showCard.startAnimation()
    }
    
    private func hideCardAndGoBack() {
        // ensure there's no pending layout changes before animation runs
        self.view.layoutIfNeeded()
        
        // set the new top constraint value for card view
        // card view won't move down just yet, we need to call layoutIfNeeded()
        // to tell the app to refresh the frame/position of card view
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
          let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
          
          // move the card view to bottom of screen
          cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
        }
        
        // move card down to bottom
        // create a new property animator
        let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
          self.view.layoutIfNeeded()
        })
        
        // hide dimmer view
        // this will animate the dimmerView alpha together with the card move down animation
        hideCard.addAnimations {
          self.dimmerView.alpha = 0.0
        }
        
        // when the animation completes, (position == .end means the animation has ended)
        // dismiss this view controller (if there is a presenting view controller)
        hideCard.addCompletion({ position in
          if position == .end {
            if(self.presentingViewController != nil) {
              self.dismiss(animated: false, completion: nil)
            }
          }
        })
        
        // run the animation
        hideCard.startAnimation()
    }
    
    private func dimAlphaWithCardTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha : CGFloat = 0.7
      
        // ensure safe area height and safe area bottom padding is not nil
        guard let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else {
                return fullDimAlpha
        }
      
        // when card view top constraint value is equal to this,
        // the dimmer view alpha is dimmest (0.7)
        let fullDimPosition = (safeAreaHeight + bottomPadding) / 2.0
      
        // when card view top constraint value is equal to this,
        // the dimmer view alpha is lightest (0.0)
        let noDimPosition = safeAreaHeight + bottomPadding
      
        // if card view top constraint is lesser than fullDimPosition
        // it is dimmest
        if value < fullDimPosition {
            return fullDimAlpha
        }
      
        // if card view top constraint is more than noDimPosition
        // it is dimmest
        if value > noDimPosition {
            return 0.0
        }
      
        // else return an alpha value in between 0.0 and 0.7 based on the top constraint value
        return fullDimAlpha * 1 - ((value - fullDimPosition) / fullDimPosition)
    }
}
