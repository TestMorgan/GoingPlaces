//
//  HistoryInteractor.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/8/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation

final class HistoryInteractor {
    
    weak var presenter: HistoryPresenter?
    let placeDataManager = PlaceDataManager()
    
    init(presenter: HistoryPresenter) {
        self.presenter = presenter
    }
    
    func fetchPlaces() {
        let places = placeDataManager.getPlaces()
        presenter?.didFetchPlaces(places: places)
    }
    
    func savePlace(place: Place) {
        placeDataManager.save(place: place)
    }
    
}
