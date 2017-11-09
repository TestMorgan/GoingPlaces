//
//  MainBuilder.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/8/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import UIKit

final class MainBuilder {
    
    func build(with place: Place? = nil) -> UIViewController? {
        guard let viewController = mainViewController() else {
            return nil
        }
        
        let mainPresenter = MainPresenter(view: viewController)
        let mainInteractor = MainInteractor(presenter: mainPresenter)
        mainPresenter.interactor = mainInteractor
        mainPresenter.displayedPlace = place
        
        if let place = place {
            mainPresenter.savePlace(place: place)
        }
        
        viewController.presenter = mainPresenter
        return viewController
    }
    
    private func mainViewController() -> ViewController? {
        let storyboard = ViewController.parentStoryboard
        let viewController = storyboard.instantiateViewController(withIdentifier: ViewController.identifier) as? ViewController
        return viewController
    }

}
