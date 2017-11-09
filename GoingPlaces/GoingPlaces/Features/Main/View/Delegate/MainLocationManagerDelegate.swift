//
//  ViewController+LocationManagerDelegate.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/5/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import CoreLocation

final class MainLocationManagerDelegate: LocationManagerDelegate {
    
    weak var presenter: MainPresenter?
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
    }
    
    func authorizationDidChange(to: AuthorizationStatus) {
        if to == .authorized && presenter?.displayedPlace == nil {
            presenter?.searchCurrentPlace()
        }
    }
}
