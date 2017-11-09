//
//  MainPresenter.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/8/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation

final class MainPresenter {
    
    var interactor: MainInteractor?
    weak var view: ViewController?
    var autocompleteDelegate: MainAutocompleteViewControllerDelegate?
    var contactDelegate: MainContactPickerDelegate?

    var displayedPlace: Place?
    
    init(view: ViewController) {
        self.view = view
        autocompleteDelegate = MainAutocompleteViewControllerDelegate(presenter: self)
        contactDelegate = MainContactPickerDelegate(presenter: self)
    }
    
    func searchCurrentPlace() {
        interactor?.searchCurrentPlace()
    }
    
    func newPlaceFetched(place: Place) {
        displayedPlace = place
        view?.showPlace(newPlace: place)
    }
    
    func savePlace(place: Place) {
        interactor?.savePlace(place: place)
    }
    
    func presentAlert(title: String, message: String) {
        view?.presentAlert(title: title, message: message)
    }
    
    func fetchCurrentPlaceIfAuthorized() -> Bool {
        return interactor?.locationManager.status == .authorized
    }
    
}
