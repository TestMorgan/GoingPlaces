//
//  ViewController+LocationManagerDelegate.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/5/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import CoreLocation

extension ViewController: LocationManagerDelegate {
    
    func authorizationDidChange(to: AuthorizationStatus) {
        if to == .authorized && displayedPlace == nil {
            searchCurrentPlace()
        }
    }
    
    func newLocation(location: CLLocation) {
        if displayedPlace == nil {
            zoomToPlace(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
}
