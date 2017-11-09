//
//  LocationManager.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/1/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    
    func authorizationDidChange(to: AuthorizationStatus)
}

enum AuthorizationStatus {
    case authorized
    case denied
    case notDetermined
    case restricted
    
    static func adapt(from: CLAuthorizationStatus) -> AuthorizationStatus {
        if from == .authorizedAlways || from == .authorizedWhenInUse {
            return .authorized
        } else if from == .notDetermined {
            return .notDetermined
        } else if from == .denied {
            return .denied
        } else if from == .restricted {
            return .restricted
        }
        
        return .denied
    }
}

/// Location manager.
final class LocationManager: NSObject {
    
    let manager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    var status: AuthorizationStatus {
        return AuthorizationStatus.adapt(from: CLLocationManager.authorizationStatus())
    }
    
    override init() {
        super.init()
        
        self.manager.distanceFilter = kCLDistanceFilterNone
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.distanceFilter = 50
        
        if status == .notDetermined {
            self.manager.requestAlwaysAuthorization()
        }
        
        if status == .authorized {
            self.manager.startUpdatingLocation()
        }
    }
    
    
}

extension LocationManager: CLLocationManagerDelegate {
   
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let authorizationStatus = AuthorizationStatus.adapt(from: status)
        delegate?.authorizationDidChange(to: authorizationStatus)
    }
    
}
