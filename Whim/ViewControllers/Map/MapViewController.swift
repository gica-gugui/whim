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

        cardView.addGestureRecognizer(viewPan)
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        poiImagesCollectionView.dataSource = self
        
        poiImagesCollectionView.showsHorizontalScrollIndicator = false
        poiImagesCollectionView.showsVerticalScrollIndicator = false
        
        poiImagesCollectionView.register(UINib(nibName: PoiImageCollectionViewCell.nameOfClass, bundle: nil), forCellWithReuseIdentifier: PoiImageCollectionViewCell.nameOfClass)
    }
    
    private func setupViewModel() {
        self.viewModel.onPoisLoaded = { [weak self] mapAnnotations in
             self?.setMapAnnotations(annotations: mapAnnotations)
        }
        
        self.viewModel.onPoiLoaded = { [weak self] poi in
            self?.setPOIDetails(poi: poi)
            self?.poiImagesCollectionView.reloadData()
        }
        
        self.viewModel.onDirectionComputed = { [weak self] routes in
            guard routes.count > 0 else {
                return
            }
            
            let polylines = routes.map { route in
                return route.polyline
            }
            
            self?.mapView.addOverlays(polylines)
  
            self?.centerMapToPolylines(polylines: polylines)
        }
        
        self.viewModel.onModalStateChanged = { [weak self] state in
            switch state {
            case .closed:
                self?.onModalClosed()
            
            case let .opened(mapAnnotation):
                self?.onModalOpened(mapAnnotation: mapAnnotation)
            
            case .directions:
                self?.onDirectionsOpened(alternateDirections: false)
            
            case .routes:
                self?.onDirectionsOpened(alternateDirections: true)
            
            default:
                return
            }
        }
    }
    
    private func onModalOpened(mapAnnotation: MapAnnotation) {
        viewModel.loadPointOfInterest(mapAnnotation: mapAnnotation)
        
        showCard()
    }
    
    private func onModalClosed() {
        hideCardAndGoBack()
        
        deselectAllAnnotations()
        
        removeMapOverlays()
        
        addAnnotationsWithoutInteraction()
        
        resetPoiLabels()
        
        viewModel.resetPoiDetails()
        
        poiImagesCollectionView.reloadData()
    }
    
    private func onDirectionsOpened(alternateDirections: Bool) {
        showCard(atState: .normal)
        
        removeAnnotationsWithoutInteraction()
        
        removeMapOverlays()
        
        viewModel.loadDirections(alternateDirections: alternateDirections)
        
        dimmerView.alpha = 0
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
        
        guard let centerRegion = self.viewModel.getRegionForCenter() else {
            return
        }
        
        self.mapView.setRegion(centerRegion, animated: true)
    }
    
    private func setPOIDetails(poi: POIDetails) {
        self.poiTitleLabel.text = poi.title
        self.poiDescriptionLabel.text = poi.description
        
    }
}

//MARK:- MapViewDelegate
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

        guard annotation.type == .poi else {
            return
        }
        
        viewModel.setModalState(state: .opened(annotation))
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        viewModel.setModalState(state: .closed)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        
        if overlay is MKPolyline {
            if mapView.overlays.count == 1 {
                renderer.strokeColor = UIColor.red
                renderer.lineWidth = 5
            } else {
                renderer.strokeColor = mapView.overlays.count % 2 == 0 ? UIColor.blue : UIColor.purple
                renderer.lineWidth = 4
            }
        }
        
        return renderer
    }
    
    private func deselectAllAnnotations() {
        for annotation in mapView.selectedAnnotations {
            mapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
    private func centerMapToAnnotation(annotation: MapAnnotation) {
        guard let region = viewModel.getRegionForAnnotation(annotation.coordinate) else {
            return
        }

        let fittedRegion = mapView.regionThatFits(region)
        
        let translatedRegion = viewModel.getTranslatedRegion(fittedRegion)
        
        mapView.setRegion(translatedRegion, animated: true)
    }
    
    private func centerMapToPolylines(polylines: [MKPolyline]) {
        guard let translatedRegion = viewModel.getTranslatedRegion(polylines) else {
            return
        }
        
        mapView.setRegion(translatedRegion, animated: true)
    }
    
    private func addAnnotationsWithoutInteraction() {
        let annotations = viewModel.getAnnotationsWithoutInteraction()
        var annotationsToAdd = [MapAnnotation]()
        
        for annotation in annotations {
            if mapView.annotations.first(where: { ($0 as? MapAnnotation)?.pageId == annotation.pageId }) == nil {
                annotationsToAdd.append(annotation)
            }
        }
        
        mapView.addAnnotations(annotationsToAdd)
    }
    
    private func removeAnnotationsWithoutInteraction() {
        let annotations = viewModel.getAnnotationsWithoutInteraction()
        
        mapView.removeAnnotations(annotations)
    }
    
    private func removeMapOverlays() {
        mapView.removeOverlays(mapView.overlays)
    }
}

//MARK:- Modal handling
extension MapViewController {
    @IBAction func dimmerViewTapped(_ sender: UITapGestureRecognizer) {
        if viewModel.isInDirectionsMode() {
            return
        }
        
        viewModel.setModalState(state: .closed)
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
        
            if !viewModel.isInDirectionsMode() {
                // change the dimmer view alpha based on how much user has dragged
                dimmerView.alpha = dimAlphaWithCardTopConstraint(value: self.cardViewTopConstraint.constant)
            }

        case .ended:
            if velocity.y > 1500.0 {
                viewModel.setModalState(state: .closed)
                return
            }
        
            if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
                let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
              
                if self.cardViewTopConstraint.constant < (safeAreaHeight + bottomPadding) * 0.25 {
                showCard(atState: .expanded)
                } else if self.cardViewTopConstraint.constant < (safeAreaHeight) - 70 {
                    showCard(atState: .normal)
                } else {
                    viewModel.setModalState(state: .closed)
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
        viewModel.setModalState(state: .directions)
    }
    
    @IBAction private func poiRoutesButtonTap(_ sender: Any) {
        viewModel.setModalState(state: .routes)
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
      
        if !viewModel.isInDirectionsMode() {
            // show dimmer view
            // this will animate the dimmerView alpha together with the card move up animation
            showCard.addAnimations {
                self.dimmerView.alpha = 0.7
            }
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
    
    private func resetPoiLabels() {
        self.poiTitleLabel.text = ""
        self.poiDescriptionLabel.text = ""
    }
}

//MARK:- UICollectionViewDataSource
extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let poiImages = viewModel.getPoiImages()

        if poiImages.count == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PoiImageCollectionViewCell.nameOfClass, for: indexPath) as? PoiImageCollectionViewCell else {
                fatalError("Cell \(PoiImageCollectionViewCell.nameOfClass) does not exist in storyboard")
            }

            cell.configureCell(url: nil)

            return cell
        }

        let contentUrl = poiImages[indexPath.row].url

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PoiImageCollectionViewCell.nameOfClass, for: indexPath) as? PoiImageCollectionViewCell else {
            fatalError("Cell \(PoiImageCollectionViewCell.nameOfClass) does not exist in storyboard")
        }

        cell.configureCell(url: contentUrl)

        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let poiImagesCount = viewModel.getPoiImages().count
        
        return poiImagesCount > 0 ? poiImagesCount : 1
    }
}
