//
//  MainInteractor.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/8/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps

final class MainInteractor {
    
    weak var presenter: MainPresenter?
    let placesClient = GMSPlacesClient.shared()
    let placeDataManager = PlaceDataManager()
    let locationManager = LocationManager()
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
        
        locationManager.delegate = MainLocationManagerDelegate(presenter: presenter)
    }
    
    func searchCurrentPlace() {
        placesClient.currentPlace { [weak self] (placeLikelihoodList, error) in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                guard let place = placeLikelihoodList.likelihoods.first?.place else {
                    return
                }
                
                let newPlace = Place.fromGMSPlace(gmsplace: place)
                self?.presenter?.newPlaceFetched(place: newPlace)
            }
            
        }
    }
    
    func savePlace(place: Place) {
        placeDataManager.save(place: place)
    }
    
}
