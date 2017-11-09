//
//  ViewController+GMSAutoCompleteViewControllerDelegate.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/5/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import GooglePlaces

final class MainAutocompleteViewControllerDelegate: NSObject, GMSAutocompleteViewControllerDelegate {
    
    weak var presenter: MainPresenter?
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        viewController.dismiss(animated: true, completion: {
            let newPlace = Place.fromGMSPlace(gmsplace: place)
            self.presenter?.newPlaceFetched(place: newPlace)
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
