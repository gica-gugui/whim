//
//  MapViewController.swift
//  Whim
//
//  Created by Gica Gugui on 10/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

class MapViewController: BaseViewController, MapViewProtocol, IntermediableProtocol {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var separatorTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var poiTitleLabel: UILabel!
    @IBOutlet weak var poiDescriptionLabel: UILabel!
    @IBOutlet weak var poiImagesCollectionView: UICollectionView!
    @IBOutlet weak var poiLinkButton: UIButton!
    @IBOutlet weak var poiNavigationButton: UIButton!
    @IBOutlet weak var poiRoutesButton: UIButton!
    
    var openWikipediaArticle: ((_ url: String) -> Void)?
    
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
        self.viewModel.onPoisLoaded = { [weak self] mapAnnotations in
             self?.setMapAnnotations(annotations: mapAnnotations)
        }
        
        self.viewModel.onPoiLoaded = { [weak self] poi in
            self?.setPOIDetails(poi: poi)
        }
        
        self.viewModel.onDirectionComputed = { [weak self] routes in
            guard let route = routes.first else {
                return
            }
            
            self?.mapView.addOverlay(route.polyline)
            self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    func locationObtained(location: CLLocation) {
        self.setCurrentLocation(location: location)
        
        self.viewModel.loadPointOfInterests(location: location)
    }
    
    private func setCurrentLocation(location: CLLocation) {
        let mapAnnotation = MapAnnotation(
            title: NSLocalizedString("mapAnnotation.title", comment: ""),
            type: .currentLocation,
            coordinate: location.coordinate,
            distance: 0,
            color: UIColor.systemGreen,
            pageId: nil)
            
        self.mapView.addAnnotation(mapAnnotation)
        
        self.mapView.setCenter(location.coordinate, animated: true)
    }
    
    private func setMapAnnotations(annotations: [MapAnnotation]) {
        self.mapView.addAnnotations(annotations)
        
        guard let annotationsRegion = self.viewModel.getAnnotationsRegion() else {
            return
        }
        
        self.mapView.setRegion(annotationsRegion, animated: true)
    }
    
    private func setPOIDetails(poi: POIDetails) {
        self.poiTitleLabel.text = poi.title
        self.poiDescriptionLabel.text = poi.description
        
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
        guard let annotation = view.annotation as? MapAnnotation else {
            return
        }
        
        centerMapToAnnotation(annotation: annotation)
        
        // center the map for any annotation tapped, including the you are here one, but open modal only for POI
        guard annotation.type == .poi else {
            return
        }
        
        self.resetDetailsView()
        
        viewModel.loadPointOfInterest(mapAnnotation: annotation)
        
        showCard()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        
        return renderer
    }
    
    private func deselectAllAnnotations() {
        for annotation in mapView.selectedAnnotations {
            mapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
    private func centerMapToAnnotation(annotation: MapAnnotation) {
        guard let distance = viewModel.getAnnotationsMaxDistance() else {
            return
        }
        
        let oldRegion = mapView.regionThatFits(MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance))
        let centerPointOldRegion = oldRegion.center
        
        let centerPointNewRegion = CLLocationCoordinate2D.init(latitude: centerPointOldRegion.latitude - oldRegion.span.latitudeDelta / 4.0, longitude: centerPointOldRegion.longitude)
        let newRegion = MKCoordinateRegion(center: centerPointNewRegion, span: oldRegion.span)
        
        mapView.setRegion(newRegion, animated: true)
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
    
    @IBAction private func poiLinkButtonTap(_ sender: Any) {
        guard let wikiUrl = self.viewModel.getWikipediaLink() else {
            return
        }
        
        self.openWikipediaArticle?(wikiUrl)
    }
    
    @IBAction private func poiNavigationButtonTap(_ sender: Any) {
        showCard(atState: .normal)
        
        viewModel.loadDirections()
    }
    
    @IBAction private func poiRoutesButtonTap(_ sender: Any) {
        
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
        
        self.deselectAllAnnotations()
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
    
    private func resetDetailsView() {
        self.poiTitleLabel.text = ""
        self.poiDescriptionLabel.text = ""
    }
}
