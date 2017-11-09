//
//  HistoryPresenter.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/8/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation

final class HistoryPresenter {
    
    var interactor: HistoryInteractor?
    weak var view: HistoryTableViewController?
    
    init(view: HistoryTableViewController) {
        self.view = view
    }

    func fetchPlaces() {
        interactor?.fetchPlaces()
    }
    
    func didFetchPlaces(places: [Place]) {
        view?.showPlaces(places: places)
    }
    
}
