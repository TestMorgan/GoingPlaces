//
//  ViewController+MFMessageComposeViewControllerDelegate.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/5/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import MessageUI

extension ViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        controller.dismiss(animated: true, completion: {
            if result == .sent {
                // Save it locally.
                if let displayedPlace = self.displayedPlace,
                    let to = controller.subject {
                    let sentPlace = Place.sentPlace(place: displayedPlace, to: to)
                    self.placeDataManager.save(place: sentPlace)
                }
                
                self.presentAlert(title: "Success", message: "Location sent!")
            }
        })
    }
    
}


extension ViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: {
            if result == .sent {
                // Save it locally.
                if let displayedPlace = self.displayedPlace,
                    let to = controller.title {
                    let sentPlace = Place.sentPlace(place: displayedPlace, to: to)
                    self.placeDataManager.save(place: sentPlace)
                }
                
                self.presentAlert(title: "Success", message: "Location sent!")
            }
        })
    }

    
}
