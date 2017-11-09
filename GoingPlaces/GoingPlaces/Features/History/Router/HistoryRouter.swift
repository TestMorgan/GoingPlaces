//
//  HistoryRouter.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/8/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import UIKit

final class HistoryRouter {
    
    func routeToHistory(navigationController: UINavigationController?, mainPresenter: MainPresenter) {
        let builder = HistoryBuilder()
        guard let viewController = builder.build(with: mainPresenter) else {
            // Could not build History view controller.
            return
        }
    
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeBack(navigationController: UINavigationController?) {
        navigationController?.popViewController(animated: true)
    }
    
}
