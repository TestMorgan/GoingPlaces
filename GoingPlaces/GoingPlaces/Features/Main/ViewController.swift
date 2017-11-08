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

    var placesClient: GMSPlacesClient!
    let placeDataManager = PlaceDataManager()
    let locationManager = LocationManager()
    
    var displayedPlace: Place? {
        didSet {
            guard let displayedPlace = displayedPlace else {
                return
            }
            zoomToPlace(latitude: displayedPlace.coordinate.latitude, longitude: displayedPlace.coordinate.longitude)
            addMarker(place: displayedPlace)
        }
    }
    
    var mapView: GMSMapView?
    @IBOutlet private weak var shareButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        setupDesign()
        
        if let displayedPlace = displayedPlace {
            zoomToPlace(latitude: displayedPlace.coordinate.latitude, longitude: displayedPlace.coordinate.longitude)
            addMarker(place: displayedPlace)
        } else {
            if locationManager.status == .authorized {
                searchCurrentPlace()
            }
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
    
    func setup(with place: Place) {
        placeDataManager.save(place: place)
        displayedPlace = place
    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
    }

    @objc func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @objc func historyClicked() {
        let historyViewController = HistoryTableViewController.parentStoryboard.instantiateViewController(withIdentifier: HistoryTableViewController.identifier) as! HistoryTableViewController
        historyViewController.placeDataManager = placeDataManager
        navigationController?.pushViewController(historyViewController, animated: true)
    }
    
    @objc func shareClicked() {
        guard let _ = mapView?.selectedMarker else {
            presentAlert(title: "Error", message: "Please select a pin on the map to share a location.")
            return
        }
        
        let pickerViewController = CNContactPickerViewController()
        pickerViewController.delegate = self
        pickerViewController.displayedPropertyKeys = [CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
        present(pickerViewController, animated: true, completion: nil)
    }
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func searchCurrentPlace() {
        placesClient = GMSPlacesClient.shared()
        placesClient.currentPlace { [weak self] (placeLikelihoodList, error) in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                guard let place = placeLikelihoodList.likelihoods.first?.place else {
                    return
                }
                
                self?.displayedPlace = Place.fromGMSPlace(gmsplace: place)
            }
            
        }
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
