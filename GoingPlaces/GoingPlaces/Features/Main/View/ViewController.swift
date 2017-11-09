//
//  ViewController.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/1/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import UIKit
import ContactsUI
import GooglePlaces
import GoogleMaps

final class ViewController: UIViewController {

    var presenter: MainPresenter!
    
    let mainRouter: MainRouter = MainRouter()
    private let historyRouter: HistoryRouter = HistoryRouter()
    
    var mapView: GMSMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        
        if let displayedPlace = presenter?.displayedPlace {
            zoomToPlace(latitude: displayedPlace.coordinate.latitude, longitude: displayedPlace.coordinate.longitude)
            addMarker(place: displayedPlace)
        } else if presenter?.fetchCurrentPlaceIfAuthorized() == true {
            searchCurrentPlace()
        }
    }
    
    func setupDesign() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(autocompleteClicked))
        navigationItem.rightBarButtonItem = rightBarButton
        
        let rightBarButton2 = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(historyClicked))
        navigationItem.rightBarButtonItems = [rightBarButton2, rightBarButton]
        
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareClicked))
        navigationItem.leftBarButtonItem = leftBarButton
        title = "Going Places"
    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 40.7128, longitude: -74.0060, zoom: 9.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
    }

    @objc func autocompleteClicked() {
        guard let autocompleteDelegate = presenter.autocompleteDelegate else {
            return
        }
        
        mainRouter.routeToAutoCompletePlaces(viewController: self, delegate: autocompleteDelegate)
    }
    
    @objc func historyClicked() {
        historyRouter.routeToHistory(navigationController: navigationController, mainPresenter: presenter)
    }
    
    @objc func shareClicked() {
        guard let _ = mapView?.selectedMarker,
            let delegate = presenter?.contactDelegate else {
            presentAlert(title: "Error", message: "Please select a pin on the map to share a location.")
            return
        }
        
        mainRouter.routeToShare(viewController: self, delegate: delegate)
    }
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func searchCurrentPlace() {
        presenter?.searchCurrentPlace()
    }
    
    func showPlace(newPlace: Place) {
        zoomToPlace(latitude: newPlace.coordinate.latitude, longitude: newPlace.coordinate.longitude)
        addMarker(place: newPlace)
    }
    
    func zoomToPlace(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude,
                                              longitude: longitude,
                                              zoom: 15)
        
        if mapView?.isHidden == true {
            mapView?.isHidden = false
            mapView?.camera = camera
        } else {
            mapView?.animate(to: camera)
        }
    }
    
    func addMarker(place: Place) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.title = place.name
        marker.snippet = place.address
        marker.map = mapView
        mapView?.selectedMarker = marker
    }
    
}


extension ViewController: Identifiable {
    
    static var identifier: String = "ViewController"
    static var parentStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
}
