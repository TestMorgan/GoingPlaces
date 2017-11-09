//
//  HistoryBuilder.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/8/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import UIKit

final class HistoryBuilder {
    
    func build(with mainPresenter: MainPresenter) -> UIViewController? {
        guard let viewController = historyViewController() else {
            return nil
        }
        
        let historyPresenter = HistoryPresenter(view: viewController)
        let historyInteractor = HistoryInteractor(presenter: historyPresenter)
        historyPresenter.interactor = historyInteractor
        viewController.presenter = historyPresenter
        viewController.mainPresenter = mainPresenter
        return viewController
    }
    
    private func historyViewController() -> HistoryTableViewController? {
        let storyboard = HistoryTableViewController.parentStoryboard
        let historyViewController = storyboard.instantiateViewController(withIdentifier: HistoryTableViewController.identifier) as? HistoryTableViewController
        return historyViewController
    }
    
}
