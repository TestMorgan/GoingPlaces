//
//  ViewController+MFMessageComposeViewControllerDelegate.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/5/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import MessageUI

final class MainMFMessageComposeViewController: NSObject, MFMessageComposeViewControllerDelegate {
    
    weak var presenter: MainPresenter?
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        controller.dismiss(animated: true, completion: {
            if result == .sent {
                // Save it locally.
                if let displayedPlace = self.presenter?.displayedPlace,
                    let to = controller.subject {
                    let sentPlace = Place.sentPlace(place: displayedPlace, to: to)
                    self.presenter?.savePlace(place: sentPlace)
                }
                
                self.presenter?.presentAlert(title: "Success", message: "Location sent!")
            }
        })
    }
    
}
