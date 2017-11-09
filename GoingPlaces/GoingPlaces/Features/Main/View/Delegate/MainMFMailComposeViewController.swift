//
//  MainMFMailComposeViewController.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/8/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import MessageUI

final class MainMFMailComposeViewController: NSObject, MFMailComposeViewControllerDelegate {
    
    weak var presenter: MainPresenter?
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: {
            if result == .sent {
                // Save it locally.
                if let displayedPlace = self.presenter?.displayedPlace,
                    let to = controller.title {
                    let sentPlace = Place.sentPlace(place: displayedPlace, to: to)
                    self.presenter?.savePlace(place: sentPlace)
                }
                
                self.presenter?.presentAlert(title: "Success", message: "Location sent!")
            }
        })
    }
    
    
}
